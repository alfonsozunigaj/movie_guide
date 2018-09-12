Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redistogo:f2fb6e50b757a24bc7af49f73eb6de20@spinyfin.redistogo.com:9933/' }
  # config.redis = { url: 'redis://localhost:6379/0' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redistogo:f2fb6e50b757a24bc7af49f73eb6de20@spinyfin.redistogo.com:9933/' }
    # config.redis = { url: 'redis://localhost:6379/0' }
end
