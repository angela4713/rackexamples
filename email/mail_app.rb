require 'rack/utils'
require './mailer'

class MailApp
  def call(env)
    case env["REQUEST_METHOD"]
      when "GET"
        case env["PATH_INFO"]
          when "/"
            return render "form.html"
        end
      when "POST"
        case env["PATH_INFO"]
          when "/send"
            form = Rack::Utils.parse_nested_query(env["rack.input"].read)
            mailer = Mailer.new(form["from_name"], form["from"], form["to"])
            if mailer.send_email(form["subject"], form["message"])
              return render "sent.html"
            else
              return render "error.html"
            end
        end
    end
    [404, {"Content-Type" => "text/plain"}, ["Error 404: Page not found"]]
  end

  private

  def render(file)
    return [200, {"Content-Type" => "text/html"}, [File.read(file)]]
  end
end