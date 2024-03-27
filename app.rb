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
    slim(:register)
end

get('/showlogin') do
    slim(:login)
end

post('/login') do
    username = params[:username]
    password = params[:password]
    db = SQLite3::Database.new('db/wsprojekt.db')
    db.results_as_hash = true
    result = db.execute("SELECT * FROM users WHERE username = ?", username).first
    pwdigest = result["pwdigest"]
    id = result["id"]

    if BCrypt::Password.new(pwdigest) == password
        session[:id] = id
        redirect('/mypage')
    else
        "Wrong password"
    end
end

get('/mypage') do
    id = session[:id].to_i
    db = SQLite3::Database.new('db/wsprojekt.db')
    db.results_as_hash = true
    result = db.execute("SELECT * FROM Countries WHERE country-id = ?", id)
    slim(:"/mypage/index", locals:{mypage:result})
end

post('/users/new') do
    username = params[:username]
    password = params[:password]
    password_confirm = params[:password_confirm]
    db = SQLite3::Database.new('db/wsprojekt.db')
    existing_user = db.execute('SELECT * FROM Users WHERE Username = ?', username).first

    if existing_user
        slim(:signup_error)
    elsif password != password_confirm
        slim (:password_mismatch_error)
    else
        password_digest = BCrypt::Password.create(password)
        db = SQLite3::Database.new('db/wsprojekt.db')
        db.execute("INSERT INTO users (username, pwdigest) VALUES (?,?)", username, password_digest)
        redirect('/')
    end
end

get ("/offers") do 
    slim(:offers)
end