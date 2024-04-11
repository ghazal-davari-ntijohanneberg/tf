require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require 'sinatra/reloader'

enable :sessions

get('/') do
    slim(:index)
end

get('/register') do
    slim(:"login/register")
end

get('/showlogin') do
    slim(:"login/login")
end

get('/special') do
    if session[:username]
        slim(:special)
    else 
        "You must be logged in to view this page"
    end
end
  
post('/login') do
    username = params[:username]
    password = params[:password]
    db = SQLite3::Database.new('db/wsprojekt.db')
    db.results_as_hash = true
    result = db.execute("SELECT * FROM users WHERE username = ?", username).first
    pwdigest = result["pwdigest"]
    user_id = result["user_id"].to_i

    if BCrypt::Password.new(pwdigest) == password
        session[:user_id] = user_id
        session[:username] = username
        puts "Session ID: #{session[:user_id]}"
        redirect('/mypage')
    else
        "Wrong password"
    end
end

get('/mypage') do
    id = session[:user_id].to_i
    db = SQLite3::Database.new('db/wsprojekt.db')
    db.results_as_hash = true
    @travels = db.execute("SELECT * FROM  Travels
                            INNER JOIN Countries ON Travels.country_id = Countries.country_id
                            WHERE user_id = ?",id)
    p @travels
    slim(:"mypage/index")
end

post('/users/new') do
    username = params[:username]
    password = params[:password]
    password_confirm = params[:password_confirm]
    db = SQLite3::Database.new('db/wsprojekt.db')
    existing_user = db.execute('SELECT * FROM Users WHERE Username = ?', username).first

    if existing_user
        slim(:"login/signup_error")
    elsif password != password_confirm
        slim (:password_mismatch_error)
    else
        pwdigest = BCrypt::Password.create(password)
        db = SQLite3::Database.new('db/wsprojekt.db')
        db.execute("INSERT INTO users (username, pwdigest) VALUES (?,?)", username, pwdigest)
        redirect('/')
    end
end

get ("/offers") do 
    slim(:offers)
end

post ('/add_to_travel_plan') do
    if session[:user_id].nil?
        puts "Redirecting to login page" 
        redirect '/showlogin'
    else
        country_id = params[:country_id].to_i
        user_id = session[:user_id]

        db = SQLite3::Database.new('db/wsprojekt.db')
        db.execute("INSERT INTO Travels (country_id, user_id) VALUES (?, ?)", country_id, user_id)
    
        redirect '/offers'
    end
end

post('/Travels/:country_id/delete') do
    country_id = params[:country_id].to_i
    db = SQLite3::Database.new('db/wsprojekt.db')
    db.execute("DELETE FROM Travels WHERE country_id = ?", country_id)
    redirect '/mypage'
end

get '/logout' do
    session.clear  
    redirect '/'   
end