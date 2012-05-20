require 'erb'

x = 1
42.times do
	x = x + 1
end
template = ERB.new <<-EOF
	<h1>De waarde van x is : <%= x %></h1>
	EOF
RB2OBJC::invoke('outputWebView', 'loadHTMLString:baseURL:', [template.result(binding), nil])

RB2OBJC::invoke('outputTextView', 'setText:', ['De waarde van x is : ' + x.to_s])

RB2OBJC::invoke('drawingView', 'drawLineFromX1:andX2:toY1:andY2:', [0, 0, 100, 100])
RB2OBJC::invoke('drawingView', 'drawLineFromX1:andX2:toY1:andY2:', [100, 100, 400, 20])

#RB2OBJC::alert('Test afgelopen')




GuineaCounter = Class.new
shared_count = 0
GuineaCounter.send :define_method, :double_count do
	shared_count += 1
	@count ||= 0
	@count += 1
end
#first_counter = GuineaCounter.new
#first_counter.double_count

#RB2OBJC::invoke('outputTextView', 'setText', ['Het resultaat : ' + first_counter.double_count.to_s])
