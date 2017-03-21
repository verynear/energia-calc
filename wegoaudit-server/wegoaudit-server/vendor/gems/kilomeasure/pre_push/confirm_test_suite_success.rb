module Overcommit
  module Hook
    module PrePush
      # Prompts for confirmation of successful test suite run prior to pushing
      # to specific branches
      #
      class ConfirmTestSuiteSuccess < Base
        def run
          return :pass unless pushing_to_relevant_branch?
          puts ''
          print prompt_message
          STDIN.reopen(File.open('/dev/tty', 'r'))
          if STDIN.gets.strip.downcase == 'yes'
            :pass
          else
            [:fail, "Try again after running the test suite\n"]
          end
        end

        private

        # Default to master branch, but allow setting branch in config file.
        # Useful for testing.
        def branches
          @branches = config.fetch('branches', ['master'])
        end

        def prompt_message
          'Are you SURE the test suite is green for this code? (type `yes` ' \
          'to continue, or go run CI) '
        end

        def pushing_to_relevant_branch?
          pushed_refs.any? do |pushed_ref|
            branches.include?(pushed_ref.remote_ref.sub('refs/heads/', ''))
          end
        end
      end
    end
  end
end
