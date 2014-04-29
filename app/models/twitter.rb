class Twitter
  APIKEY = ''
  APISECRET = ''
  TOKEN = ''
  SECRET = ''
  VERSION = '1.1'
  IMPORTANTS = [
    'tarbrick', 'yang8', 'shota', 'shinout', 'tnantoka', '8maki', 'satoko245',
    'hazuma', 'yanasawa', 'inoko21', 'kenichiromogi',
    'seiji_kameda', 'jack', 'usksato', 'ogijun', 'masuidrive',
    'nishio', 'woopsdez', 'koizuka', 'yomoyomo',
    'dhh', 'tnoborio', 'yukihiro_matz', 'shi3z'
  ]

  def initialize
    @access_token = access_token
    @important_ids = important_ids
  end

  def unfollow_all
    friend_ids.each do |id|
      unfollow(id) 
    end
  end

  def unfollow(id)
    return if @important_ids.include?(id)
    puts "unfollow #{id}..." 
    url = "/#{VERSION}/friendships/destroy.json"
    puts @access_token.post(url, {user_id: id})
  end

  def friend_ids
    if @twitter_ids
      @twitter_ids
    else
      url = "/#{VERSION}/friends/ids.json"
      response = @access_token.get(url)
      @twitter_ids = JSON.parse(response.body)["ids"]
    end
  end

  private

  def important_ids
    IMPORTANTS.map do |sn| 
      url = "/#{VERSION}/statuses/user_timeline.json?screen_name=#{sn}"
      res = @access_token.get(url)
      user_id = JSON.parse(res.body).first["user"]["id"]
      puts "#{sn} is #{user_id}"
      user_id
    end
  end

  def consumer
    OAuth::Consumer.new(
      APIKEY, APISECRET,
      { site: "https://api.twitter.com" }
    )
  end

  def access_token
    OAuth::AccessToken.new(
      consumer,
      TOKEN,
      SECRET
    )
  end
end
