#include <ruby.h>
#include <objc/objc.h>
#include <objc/runtime.h>
#include <UIKit/UIKit.h>
#include <EmbeddedRuby.h>

VALUE moduleRB2ObjC;
VALUE communicationArray;
VALUE cCallbackObj;
//VALUE rb_cNSDate;
//VALUE rb2objc_block_call(VALUE obj, SEL sel, int argc, VALUE *argv, VALUE (*bl_proc) (ANYARGS), VALUE data2);
//rb2objc_block_call(env, selEach, 0, 0, save_env_i, (VALUE)ary);

struct callback {
VALUE obj;
ID method;
};

VALUE 
rb2objc_cb_init(VALUE klass, VALUE obj, VALUE method) {
	
	struct callback *cb = ALLOC(struct callback);
	cb->obj = obj;
	cb->method = rb_intern(RSTRING_PTR(method));
	if (!rb_respond_to(obj, cb->method)) {
		free(cb);
		rb_raise(rb_eRuntimeError, "Target does not support operation");
	}
	return Data_Wrap_Struct(klass, 0, free, cb);
}

VALUE 
rb2objc_cb_call(VALUE self) {
	
	struct callback *cb;
	Data_Get_Struct(self, struct callback, cb);
	return rb_funcall(cb->obj, cb->method, 0, self);
}

id 
convert_value_type(VALUE inval) {
	
	switch (TYPE(inval)) {
		case T_FIXNUM:
			return (id)NUM2UINT(inval);
			break;
		case T_STRING:
			return[NSString stringWithUTF8String:RSTRING_PTR(inval)];
			break;
		case T_TRUE:
			return (id)TRUE;
			break;
		case T_NIL:
			return nil;
			break;
		case T_DATA:
			rb_raise(rb_eTypeError, "Not yet implemented");
			break;
		default:
			rb_raise(rb_eTypeError, "Not a valid value");
			break;
	}
}

VALUE
rb2objc_alert(VALUE self, VALUE message) {
	
	UIAlertView *someAlert = [[UIAlertView alloc] initWithTitle: @"Ruby2ObjectiveC" 
													   message: [NSString stringWithUTF8String:RSTRING_PTR(message)] 
													   delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil];

	[someAlert show];
	[someAlert release];
	
	return Qnil;
}

VALUE
rb2objc_send_msg(VALUE self, VALUE obj, VALUE meth, VALUE args) {
	
	// check if args is really an array
	Check_Type(args, T_ARRAY);
	
	// get the target
	id objc_obj = [[[EmbeddedRuby sharedInstance] uiElements] objectForKey:[NSString stringWithUTF8String:RSTRING_PTR(obj)]];
	// get the method
	SEL theSelector = NSSelectorFromString([NSString stringWithUTF8String:RSTRING_PTR(meth)]);

	if ( objc_obj != nil && [objc_obj respondsToSelector:theSelector] ) {
		
		// give the compiler a clue - courtesy of Greg Parker@Apple
		// see http://www.red-sweater.com/blog/320/abusing-objective-c-with-class
		int len = RARRAY(args)->len;

		// switch is not usable because of custom function pointer
		if (len == 0) {
			void (*RB2OBJCSender)(id, SEL) = (void (*)(id, SEL)) objc_msgSend;
			RB2OBJCSender(objc_obj, theSelector);
		}
		else if (len == 1) {
			void (*RB2OBJCSender)(id, SEL, id) = (void (*)(id, SEL, id)) objc_msgSend;
			RB2OBJCSender(objc_obj, theSelector, convert_value_type(RARRAY_PTR(args)[0]));
		}
		else if (len == 2) {
			void (*RB2OBJCSender)(id, SEL, id, id) = (void (*)(id, SEL, id, id)) objc_msgSend;
			RB2OBJCSender(objc_obj, theSelector, convert_value_type(RARRAY_PTR(args)[0]), convert_value_type(RARRAY_PTR(args)[1]));
		}
		else if (len == 3) {
			void (*RB2OBJCSender)(id, SEL, id, id, id) = (void (*)(id, SEL, id, id, id)) objc_msgSend;
			RB2OBJCSender(objc_obj, theSelector, convert_value_type(RARRAY_PTR(args)[0]), convert_value_type(RARRAY_PTR(args)[1]),
												 convert_value_type(RARRAY_PTR(args)[2]));
		}
		else if (len == 4) {
			void (*RB2OBJCSender)(id, SEL, id, id, id, id) = (void (*)(id, SEL, id, id, id, id)) objc_msgSend;
			RB2OBJCSender(objc_obj, theSelector, convert_value_type(RARRAY_PTR(args)[0]), convert_value_type(RARRAY_PTR(args)[1]),
												 convert_value_type(RARRAY_PTR(args)[2]), convert_value_type(RARRAY_PTR(args)[3]));
		}
		else if (len == 5) {
			void (*RB2OBJCSender)(id, SEL, id, id, id, id, id) = (void (*)(id, SEL, id, id, id, id, id)) objc_msgSend;
			RB2OBJCSender(objc_obj, theSelector, convert_value_type(RARRAY_PTR(args)[0]), convert_value_type(RARRAY_PTR(args)[1]),
												 convert_value_type(RARRAY_PTR(args)[2]), convert_value_type(RARRAY_PTR(args)[3]),
												 convert_value_type(RARRAY_PTR(args)[4]));
		}
	}
	
	return Qnil;
}

void
Init_RB2ObjC() {
	
//	rb_cNSDate = (VALUE)objc_getClass("NSDate");
	
	// get lib and script paths
	NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
	NSString *rubyLib = [NSString stringWithFormat:@"%@/lib", resourcePath];
	NSString *rubyVendor = [NSString stringWithFormat:@"%@/scripts", resourcePath];

	// add the bundle resource path to the search path
	VALUE load_path = rb_gv_get(":");
	rb_funcall(load_path, rb_intern("push"), 1, rb_str_new2([resourcePath UTF8String]));
	rb_funcall(load_path, rb_intern("push"), 1, rb_str_new2([rubyLib UTF8String]));
	rb_funcall(load_path, rb_intern("push"), 1, rb_str_new2([rubyVendor UTF8String]));
	
	// init global communication array
	communicationArray = rb_ary_new();
	rb_gv_set("$RB2OBJCArray", communicationArray);

	// add module to Ruby stack
	moduleRB2ObjC = rb_define_module("RB2OBJC");
	rb_define_singleton_method(moduleRB2ObjC, "alert", rb2objc_alert, 1);
	rb_define_singleton_method(moduleRB2ObjC, "invoke", rb2objc_send_msg, 3);
	
	// add callback object to Ruby stack
	// see http://chrislee.dhs.org/projects/ruby_cb.html
	cCallbackObj = rb_define_class_under(moduleRB2ObjC, "CallbackObj", rb_cObject);
	rb_define_singleton_method(cCallbackObj, "new", rb2objc_cb_init, 2);
	rb_define_method(cCallbackObj, "call", rb2objc_cb_call, 0);
}
