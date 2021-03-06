module Metagit
  module Support
    class RuggedRepo

      attr_accessor :commits

      def initialize repo_path, email
        @repo = Rugged::Repository.init_at repo_path
        @commits = []
        self.commit_to_repo email
        self.commit_to_repo "notme@somewhere-else.com"
        self.commit_to_repo email
      end

      def commit_to_repo email
        oid = @repo.write("This is a blob.", :blob)
        index = @repo.index
        index.add(:path => "README.md", :oid => oid, :mode => 0100644)

        options = {}
        options[:tree] = index.write_tree(@repo)

        options[:author] = { :email => email, :name => 'Test Author', :time => Time.now }
        options[:committer] = { :email => email, :name => 'Test Author', :time => Time.now }
        options[:message] ||= "A test commit"
        options[:parents] = @repo.empty? ? [] : [ @repo.head.target ].compact
        options[:update_ref] = 'HEAD'

        @commits << Rugged::Commit.create(@repo, options)
        index.write
      end
    end
  end
end
