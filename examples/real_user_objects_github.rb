$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

# Virtual user definitions
class VirtualUser

  # initializes the VirtualUser object and adds some default test
  # components.
  # @param dsl the dsl
  def initialize(dsl)
    @dsl = dsl

    defaults domain: 'github.com', # default domain if not specified in URL
      protocol: 'http', # default protocol if not specified in URL
      download_resources: true, # download images/CSS/JS
      use_concurrent_pool: 6, # mimic Chrome/IE parallelism for images/CSS/JS
      urls_must_match: '(https?.\/\/)?([^\.]*\.)*(github\.com)?\/.*' # only download resources for the target domain

    cookies # om nom nom

    cache clear_each_iteration: true # each thread iteration mimics a new user with an empty browser cache

    with_user_agent 'ie9' # send IE9 browser headers

    with_gzip # add HTTP request headers to allow GZIP compression. Most sites support this nowadays.

  end

  # Adds a user think time. Note that this is slightly different than the
  # default JMeter think time, in that it executes sequentially with test steps.
  # @param delay [int] the target pause time, in milliseconds
  # @param deviation [int] the pause deviation, in milliseconds
  def pause(delay=30000, deviation=5000)
    test_action name: 'Think Time', action: 1, target: 0, duration: 0 do
       think_time delay, deviation
    end
  end

  # Requests the home page.
  def home_page
    visit name: 'Home page', url: '/'
    pause
  end

  # Searches for a repository.
  # @param repo [String] the repository to search for
  def search_for_repository(repo)
    visit name: 'Search for project', url: '/search',
      always_encode: true,
      fill_in: {
        'q' => repo,
        'ref' => 'cmdform'
      }
    pause
  end

  # Visits a repository page.
  # @param repo_path [String] the repository URL path
  def view_repository(repo_path)
    visit name: 'Repository page', url: repo_path
    pause
  end

  # Views a branch/tag page.
  # @param branch_path [String] the branch URL path
  def view_branch(branch_path)
    visit name: 'Branch page', url: branch_path
    pause
  end

  ####################################################################
  private

  # Passes method calls through to the underlying DSL.
  # @param method the method
  # @param args the arguments
  # @param block the block
  def method_missing method, *args, &block
    @dsl.__send__ method, *args, &block
  end
  ####################################################################
end

# JMeter test plan begins here.
test do

  # Defines a thread group. We allow certain parameters to be passed in
  # as system properties.
  threads count: '${__P(threads,1)}',
    rampup: '${__P(rampup,600)}',
    name: 'Test Scenario - GitHub project navigation',
    duration: '${__P(duration, 600)}' do

    user = VirtualUser.new(self) # This will add a bunch of test components.

    # In the event of an error, the thread will start a new loop. If this
    # happens on the first request, we could start flooding the site with
    # requests.
    # To prevent this from happening, we insert a quick pause before the
    # first request.
    user.pause 1000,0

    # User workflow begins here.
    # Note that think times are defined inside the page methods.
    user.home_page
    user.search_for_repository 'ruby-jmeter'
    user.view_repository '/flood-io/ruby-jmeter'
    user.view_branch '/flood-io/ruby-jmeter/tree/v2.11.8'

  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)

