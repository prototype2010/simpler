class TestsController < Simpler::Controller

  def index
    @time = Time.now


    headers['WEIRD_HEADER'] = '1234'
    status(200)
    render(plain: "Params sent: #{@request.params}")
  end

  def create

  end

end
