require 'dm-core'
require 'dm-migrations'

class Student
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :student_id, String
  property :email, String
  property :grade, String
end

configure do
  enable :sessions
  set :username, 'teacher'
  set :password, 'teacher'
end

DataMapper.finalize

get '/students' do
  slim :entry
end

get '/student entry' do
  @s = Student.all
  slim :students
end

get '/teacher entry' do
  slim :login
end

post '/teacher entry' do
  if params[:username] == settings.username && params[:password] == settings.password
    session[:admin] = true
    redirect to('/student entry')
  else
    slim :login
  end
end

get '/logout' do
  session.clear
  redirect to('/')
end

get '/student entry/new' do
  redirect to("/unauthorized") unless session[:admin]
  @student = Student.new
  slim :new_student
end

post '/student entry' do  
  student = Student.create(params[:student])
  redirect to("/student entry/#{student.id}")
end

get '/student entry/:id' do
  redirect to("/unauthorized") unless session[:admin]
  @student = Student.get(params[:id])
  slim :show_student
end

get '/student entry/:id/edit' do
  @student = Student.get(params[:id])
  slim :edit_student
end

put '/student entry/:id' do
  student = Student.get(params[:id])
  student.update(params[:student])
  redirect to("/student entry/#{student.id}")
end

delete '/student entry/:id' do
  Student.get(params[:id]).destroy
  redirect to('/student entry')
end
