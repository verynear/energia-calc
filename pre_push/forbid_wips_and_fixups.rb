module Overcommit
  module Hook
    module PrePush
      # Fails if any commit messages in the commit range suggest works in
      # progress, fixups, or commits to be squashed.
      #
      class ForbidWipsAndFixups < Base
        def run
          return :pass unless pushing_to_relevant_branch?
          passes? ? :pass : [:fail, "WiP, fixup or squash commit found\n"]
        end

        private

        # Default to master branch, but allow setting branch in config file.
        # Useful for testing.
        def branches
          @branches = config.fetch('branches', ['master'])
        end

        def commit_range(ref)
          if ref.created?
            ref.local_sha1
          else
            "#{ref.remote_sha1}..#{ref.local_sha1}"
          end
        end

        def no_offending_commits?(ref)
          cmd = 'git rev-list -n 1 -i '
          patterns.each { |pattern| cmd += "--grep '#{pattern}' " }
          cmd += "#{commit_range(ref)}"
          `#{cmd}`.empty?
        end

        def passes?
          pushed_refs.all? do |pushed_ref|
            next true if pushed_ref.deleted?
            no_offending_commits?(pushed_ref)
          end
        end

        def patterns
          %w[
            ^fixup
            ^squash
            ^wip
          ]
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
