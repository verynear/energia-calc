module Motion
  module Project
    class Config
      def deploy?
        @deploy_mode ||= %w[staging production].include?(ENV['MOTION_ENV'])
      end

      def git_short_hash
        `git log --pretty=format:'%h' -n 1`
      end

      def env_config
        @env_config ||= begin
          YAML.load_file("config/#{ENV['MOTION_ENV'] || 'development'}.yml")
        end
      end
    end
  end
end
