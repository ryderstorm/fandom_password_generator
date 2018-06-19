# frozen_string_literal: true

PASSWORD_TYPES =
  [
    'Fallout',
    'Game of Thrones',
    # 'Generic',
    'Hacker',
    'Harry Potter',
    'Hipster',
    'Overwatch',
    'Silicon Valley',
    'Space',
    # 'Star Wars',
    'Zelda',
  ].freeze

def password_route(password_type)
  route = password_type.gsub(' ', '_').downcase
  "/#{route}_password"
end

def index_page
  mab = Markaby::Builder.new
  mab.html5 do
    head(lang: 'en') do
      title 'Random Fandom Password Generator'
      link(rel: 'icon', type: 'image/x-icon', href: '/img/favicon.ico')
      link(href: 'css/index_style.css', rel: 'stylesheet', type: 'text/css')
      script(src: 'https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js')
      script(src: 'js/script.js')
    end
    body do
      div.logowrapper do
        img.logo(src: 'img/logo.png')
      end
      div.wrapper do
        p.index_title { 'Choose the type of password you want:' }
        div.options_wrapper do
          PASSWORD_TYPES.each do |type|
            div.option do
              a.option_link.hover_grow(href: password_route(type)) { type }
            end
          end
        end
        hr
        p.footer { 'Or click ' + a(href: '/random_password') { 'here' } + ' for a random fandom' }
      end
    end
  end
  html = mab.to_s.gsub('.js"/>', '.js"></script>')
  File.write('index_page.html', HtmlBeautifier.beautify(html))
  html
end

def password_page(password_type)
  password = new_password(password_type)
  test_result = Zxcvbn.test(password)
  mab = Markaby::Builder.new
  mab.html5 do
    head(lang: 'en') do
      title "New #{password_type} password"
      link(rel: 'icon', type: 'image/x-icon', href: '/img/favicon.ico')
      link(href: 'css/style.css', rel: 'stylesheet', type: 'text/css')
      script(src: 'https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js')
      script(src: 'js/script.js')
    end
    body do
      div.wrapper do
        p.title { "Your new <span class='passwordtype'>#{password_type}</span> password is:" }
        p.password.copysource! password
        hr
        p.instructions { 'Click the buttons below to copy the password to your clipboard:' }
        div.buttonwrapper do
          button.copybutton(onclick: "copyToClipboard('#copysource')") { 'Copy as is' }
          button.copybutton(onclick: "copyToClipboardLowercase('#copysource')") { 'Copy as lowercase' }
        end
        hr
        p.footnote { "It would take <span class='cracktime'>#{test_result.crack_time_display}</span> to crack that password according to " + a(href: 'https://github.com/dropbox/zxcvbn') { 'Zxcvbn' } + '.' }
        hr
        p.footer { 'Click ' + a(href: '/') { 'here' } + ' to return to the homepage.' }
      end
    end
  end
  html = mab.to_s.gsub('.js"/>', '.js"></script>')
  File.write('password_page.html', HtmlBeautifier.beautify(html))
  html
end

def test_password(password)
  Zxcvbn.test(password)
end

def new_password(password_type)
  case password_type
  when 'Fallout'
    fallout_password
  when 'Game of Thrones'
    got_password
  when 'Hacker'
    hacker_password
  when 'Harry Potter'
    harry_potter_password
  when 'Hipster'
    hipster_password
  when 'Overwatch'
    overwatch_password
  when 'Space'
    space_password
  when 'Star Wars'
    star_wars_password
  when 'Silicon Valley'
    silicon_valley_password
  when 'Zelda'
    zelda_password
  end
end

def hacker_password
  "#{Faker::Hacker.ingverb} the #{Faker::Hacker.abbreviation} in the #{Faker::Hacker.adjective} #{Faker::Hacker.noun}"
end

def fallout_password
  emotion = %w[loves hates despises envies adores].sample
  "#{Faker::Fallout.character} #{emotion} the #{Faker::Fallout.faction}."
end

def got_password
  emotion = %w[loves hates despises envies adores].sample
  action = ['lives in', 'destroyed', 'demolished', 'obliterated', 'razed'].sample
  number = (1..2).to_a.sample
  case number
  when 1
    "#{Faker::GameOfThrones.character} #{emotion} the #{Faker::GameOfThrones.house}."
  when 2
    "#{Faker::GameOfThrones.dragon} #{action} the city of #{Faker::GameOfThrones.city}."
  end
end

def harry_potter_password
  "#{Faker::HarryPotter.character} casts #{Faker::HarryPotter.spell}"
end

def hipster_password
  Faker::Hipster.sentence(3, true)
end

def overwatch_password
  action = ['pwned everyone', 'lost it all', 'dominated', 'sucked', 'got a triple kill' ].sample
  "#{Faker::Overwatch.hero} #{action} in #{Faker::Overwatch.location}"
end

def silicon_valley_password
  number = (1..2).to_a.sample
  case number
  when 1
    "#{Faker::SiliconValley.character} created the #{Faker::SiliconValley.app} app"
  when 2
    "#{Faker::SiliconValley.character}, CEO of #{Faker::SiliconValley.company}"
  end
end

def space_password
  number = (1..2).to_a.sample
  location = [Faker::Space.star, Faker::Space.galaxy, Faker::Space.moon, Faker::Space.planet].sample
  org = [Faker::Space.agency_abv, Faker::Space.company].sample
  vessel = Faker::Space.launch_vehicule
  case number
  when 1
    "#{Faker::Space.distance_measurement} to #{location}"
  when 2
    "#{org} just launched the #{vessel}"
  end
end

def zelda_password
  number = (1..3).to_a.sample
  case number
  when 1
    "#{Faker::Zelda.character} is exploring #{Faker::Zelda.location}"
  when 2
    "#{Faker::Zelda.character} found the #{Faker::Zelda.item}"
  when 3
    item = Faker::Zelda.item
    "The #{item} #{item.end_with?('s') ? 'are' : 'is'} in #{Faker::Zelda.location}"
  end
end
