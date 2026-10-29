#The MIT License (MIT)
#
#Copyright (c) 2026 rick barrette
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module AutoAssign
  def self.setup
    TimeEntry.prepend AutoAssign::Patches::TimeEntryPatch
  end

  def self.settings
    Setting.plugin_redmine_auto_assign || {}
  rescue StandardError
    {}
  end

  # The status an issue must be at to be moved: the one chosen in settings, else the tracker's default
  # status (what new issues start as), so renaming "New" doesn't break it
  def self.starting_status_for(issue)
    chosen = settings['starting_status_id'].to_i
    (IssueStatus.find_by(id: chosen) if chosen.positive?) || issue.tracker&.default_status
  end

  # The status to move to: the one chosen in settings, else a status named "In Progress"
  def self.in_progress_status
    chosen = settings['in_progress_status_id'].to_i
    (IssueStatus.find_by(id: chosen) if chosen.positive?) || IssueStatus.find_by(name: 'In Progress')
  end
end
