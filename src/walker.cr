require "kemal"
require "json"
require "./models/"
require "./email"
require "openssl"
require "openssl/hmac"

CURR_PATH = Dir.current + "/public/threefold/info"

WEBSITES = Websites.new

def _walk(path : String = CURR_PATH)
  relative_path = Path.new path.gsub(CURR_PATH, "")
  path_parts = relative_path.parts
  if path_parts.size > 0
    path_parts.shift
  end
  level = path_parts.size
  Dir.children(path).each do |name|
    if name == ".git" || name.starts_with?(".")
      next
    end
    if ! File.file? path + "/" + name
      if level == 1
        if path_parts[0] == "circles"
          item = Project.new name
          WEBSITES.projects.push(item)
        elsif path_parts[0] == "people"
          item = User.new name
          WEBSITES.people.push(item)
        end
      end
      _walk( path + "/" + name)
    else
      if level == 2
        items = Array(Project|User).new
        if path_parts[0] == "circles"
          items = WEBSITES.projects
        elsif path_parts[0] == "people"
          items = WEBSITES.people
        end
        items.each do |item|
          image_path = ""
          logo_path = ""

          if item.name == path_parts[1]
            p = Dir.current + "/public/threefold/info" + "/" + path_parts[0] + "/" + path_parts[1] + "/" + name
            if ! name.ends_with?(".md")

              if name == "logo.png"
                logo_path = p.gsub(Dir.current + "/public", "")
                if path_parts[0] == "circles"
                  item.as(Project).links.logo_path = logo_path
                else
                  item.as(User).links.logo_path = logo_path
                end
              elsif name == "card.png"
                card_path = p.gsub(Dir.current + "/public", "")
                if path_parts[0] == "circles"
                  item.as(Project).links.card_path = card_path
                else
                  item.as(User).links.card_path = card_path
                end
              else
                if name.ends_with?(".png") || name.ends_with?(".jpeg") || name.ends_with?(".jpg")
                  image_path = p.gsub(Dir.current + "/public", "")
                  if path_parts[0] == "circles"
                    item.as(Project).links.image_path = image_path
                  else
                    item.as(User).links.image_path = image_path
                  end
  
                  
                end
              end

              
              next
            end
            page = MdPage.new name.gsub(".md", ""),  p, File.read(p)
            item.pages.push(page)
            x, parsed_codes = page.parse
            
            begin
              if path_parts[0] == "circles"
                
                if parsed_codes.size > 0
                  parsed_codes.each do |code|
                    data = code.as(Hash)
                    if data.has_key?("info")
                      info = data["info"].as(Hash)
                      links = data["links"].as(Hash)
                      ecosystem = data["ecosystem"].as(Hash)
                      
                      item.as(Project).info.mission =  info["mission"].as(String)
                      if info.has_key?("description")
                        item.as(Project).info.description =  info["description"].as(String)
                      end
                    
                      if info.has_key?("rank")
                        rank : Int64 = info["rank"].as(Int64)
                        if rank > 5_64
                          rank = 5_64
                        end

                        if rank < 1_64
                          rank = 1_64
                        end

                        item.as(Project).info.rank =  rank
                      end

                      if info.has_key?("name")
                        item.as(Project).info.name =  info["name"].as(String)
                      end
                      
                      info["team"].as(Array).each do |user|
                        u = user.as(Array)
                        item.as(Project).info.team.push TeamInfo.new u[0].as(String), u[1].as(String)
                      end

                      item.as(Project).info.countries =  Array(Country).new
                      info["countries"].as(Array).each do |country|
                        item.as(Project).info.countries.push Country.new country.as(String)
                      end

                      item.as(Project).info.cities =  Array(City).new
                      info["cities"].as(Array).each do |city|
                        item.as(Project).info.cities.push City.new city.as(String)
                      end

                      ecosystem["categories"].as(Array).each do |category|
                        item.as(Project).ecosystem.categories.push category.as(String)
                      end

                      # item.as(Project).links.linkedin =  links["linkedin"].as(String)
                      # item.as(Project).links.wiki =  links["wiki"].as(String)
                      item.as(Project).links.video =  links["video"].as(String)
                      # links["websites"].as(Array).each do |website|
                      #   item.as(Project).links.websites.push website.as(String)
                      # end
                      item.as(Project).links.threefold_circles_url =  links["threefold_circles_url"].as(String)
                      item.as(Project).links.threefold_forum_url =  links["threefold_forum_url"].as(String)
                      item.as(Project).links.freeflow_connect_room =  links["freeflow_connect_room"].as(String)
                      item.as(Project).links.chat_page_url =  links["chat_page_url"].as(String)
                      
                    elsif data.has_key?("milestone")
                      milestone = data["milestone"].as(Hash)
                      ms = MileStone.new milestone["name"].as(String), milestone["date"].as(String), milestone["funding_required_tft"].as(String), milestone["funding_required_usd"].as(String),  milestone["description"].as(String)
                      item.as(Project).milestones.push ms
                    end
                  end
                end
                
                  
              elsif path_parts[0] == "people"
                if parsed_codes.size > 0 && parsed_codes[0].has_key?("info")
                  data = parsed_codes[0].as(Hash)
                  info = data["info"].as(Hash)
                  links = data["links"].as(Hash)
                  ecosystem = data["ecosystem"].as(Hash)
                  
                  item.as(User).info.name =  info["full_name"].as(String)
                  item.as(User).info.bio =  info["bio"].as(String)
                  
                  item.as(User).info.countries =  Array(Country).new
                  info["countries"].as(Array).each do |country|
                    item.as(User).info.countries.push Country.new country.as(String)
                  end

                  item.as(User).info.cities =  Array(City).new
                  info["cities"].as(Array).each do |city|
                    item.as(User).info.cities.push City.new city.as(String)
                  end

                  item.as(User).info.circles =  Array(Circle).new
                  info["circles"].as(Array).each do |circle|
                    c  = circle.as(Array)
                    item.as(User).info.circles.push Circle.new c[0].as(String) , c[1].as(String)
                  end
                  
                  item.as(User).links.linkedin =  links["linkedin"].as(String)
                  item.as(User).links.video =  links["video"].as(String)
                  links["websites"].as(Array).each do |website|
                    item.as(User).links.websites.push website.as(String)
                  end

                  ecosystem["memberships"].as(Array).each do |membership|
                    item.as(User).ecosystem.memberships.push membership.as(String)
                  end
                end
              end
    
            rescue exception
              puts "error parsing file "  + p
              puts exception
            end
        
        end

        end
      end
    end
  end

  WEBSITES.projects.each do |item|
    item.name = item.name.gsub("_", " ")
  end
end

get "/data" do |env|
  WEBSITES.projects.clear
  WEBSITES.people.clear
  _walk 
  env.response.headers.add("Access-Control-Allow-Origin", "*")
  WEBSITES.to_json
end

get "/" do |env|
  io = IO::Memory.new
  puts env.request.host_with_port
  puts io.to_s
  c = File.read("public/index.html")
  c.gsub("{location.origin}", env.request.headers["Host"])
end

post "/join" do |env|
  params = env.params.json
  name = params["name"].as(String)
  company = params["company"].as(String)
  email= params["email"].as(String)
  about = params["about"].as(String)

  if name.strip == "" || company.strip == "" || email.strip == "" || about.strip == ""
    halt env, status_code: 400, response: "Bad request"
  end

  body = %(
    Name: #{name}
    Email: #{email}
    Company: #{company}\n
    #{about}
  )
  
  send_email(body)
end

post "/webhooks" do |env|
  body = env.params.json.to_json
  signature = "sha1=" + OpenSSL::HMAC.hexdigest(:sha1, ENV["WEBHOOK_SECRET"], body)
  githubsig= env.request.headers["X-Hub-Signature"]
  if signature == githubsig
    command = "cd " + Dir.current + "/public/threefold" + "&& git pull"
    io = IO::Memory.new
    Process.run("sh", {"-c", command}, output: io)
    puts "Done updating content"
    puts io.to_s
  end
end


get "/circles/:name" do |env|
  WEBSITES.projects.clear
  WEBSITES.people.clear
  _walk 

  name = env.params.url["name"]
  host = env.request.headers["Host"]
  useragent = env.request.headers["User-Agent"]
  
  
  if useragent.includes?("facebookexternalhit") || useragent.includes?("LinkedInBot") || useragent.includes?("Twitterbot")
    p = nil
    WEBSITES.projects.each do |item|
      if item.name == name.gsub("%20", " ")
        p = item
        break
      end
    end

    %(
<html>
  <head>
    <title>Concious Internet Alliance</title>
    <meta property="og:url"           content="https://#{host}/circles/#{name}"/>
    <meta property="og:type"          content="article" />
    <meta property="og:title"         content="#{name.capitalize}" />
    <meta property="og:description"   content="#{p.not_nil!.info.mission}" />
    <meta property="og:image"         content="https://#{host}#{p.not_nil!.links.image_path}" />
    <meta property="og:image:width" content="1200" />
    <meta property="og:image:height" content="630" />
  </head>
</html>
)
  else
    env.redirect "/#/circles/#{name}"
  end

end


get "/community/:name" do |env|
  WEBSITES.projects.clear
  WEBSITES.people.clear
  _walk 

  name = env.params.url["name"]
  host = env.request.headers["Host"]
  useragent = env.request.headers["User-Agent"]
  if useragent.includes?("facebookexternalhit") || useragent.includes?("LinkedInBot") || useragent.includes?("Twitterbot")
    p = nil
    WEBSITES.people.each do |item|
      if item.name == name.gsub("%20", " ")
        p = item
        break
      end
    end

    %(
<html>
  <head>
    <title>Concious Internet Alliance</title>
    <meta property="og:url"           content="https://#{host}/community/#{name}"/>
    <meta property="og:type"          content="article" />
    <meta property="og:title"         content="#{p.not_nil!.info.name.capitalize}" />
    <meta property="og:description"   content="" />
    <meta property="og:image"         content="https://#{host}#{p.not_nil!.links.image_path}" />
    <meta property="og:image:width" content="1200" />
    <meta property="og:image:height" content="630" />
  </head>
</html>
)
  else
    env.redirect "/#/community/#{name}"
  end

end

error 404 do |env|
  env.redirect "/#/error"
end

Kemal.run

