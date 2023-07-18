Simpler.application.routes do
  get '/tests/:id', 'tests#index'
  post '/tests', 'tests#create'
end
