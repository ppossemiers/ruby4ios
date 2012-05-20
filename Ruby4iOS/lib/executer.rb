require 'erb'

class Executer

	def execute
		
		template = %{
			<html>
			<head><title>Ruby result for <%= method %></title></head>
			<body>
			
			<h1>You called <%= method %> on class <%= obj %></h1>
			<p>And the result was : 
				<ul>
					<% methods.each do |m| %>
						<li><b><%= m %></b></li>
					<% end %>
				</ul>
			</p>
			
			</body>
			</html>
		}.gsub(/^  /, '')
		
		rhtml = ERB.new(template)

		obj = $communicationArray[0]
		method = $communicationArray[1]
		params = $communicationArray[2]
		methods = obj.methods
		
		$communicationArray[3] = rhtml.result(binding)
	end
end