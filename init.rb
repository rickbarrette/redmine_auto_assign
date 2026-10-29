#The MIT License (MIT)
#
#Copyright (c) 2026 rick barrette
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require_relative 'lib/auto_assign'
require_relative 'lib/auto_assign/patches/time_entry_patch'

Redmine::Plugin.register :redmine_auto_assign do
  name 'Redmine Auto Assign plugin'
  author 'Rick Barrette'
  description 'Automatically assigns an issue to the first user who logs time against it.'
  version '2026.3.0'
  url 'https://github.com/rickbarrette/redmine_auto_assign'
  author_url 'https://barrettefabrication.com'
  requires_redmine version_or_higher: '6.1.0'

  # Blank settings: start from each tracker's default status, move to a status named "In Progress"
  settings default: { 'starting_status_id' => '', 'in_progress_status_id' => '' },
           partial: 'settings/auto_assign_settings'
end

AutoAssign.setup