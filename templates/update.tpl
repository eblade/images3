% rebase('templates/base.tpl', title='Update')
% for job in jobs:
  <div class="job">{{job.get('job')}} {{job.get('source')}} ({{job.get('longest') or (str(job.get('width'))+'x'+str(job.get('height')))}}) {{job.get('destination')}}</div>
% end

