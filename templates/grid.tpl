% rebase('templates/base.tpl', title='Images')
<div class="top">
    <a href="{{top}}">Back to the top</a> |
    <a href="/collection:{{flt}}">Create new collection</a>
</div>
<div class="title">
    % if entry is not None:
        <span id="cats">{{entry.categories}}</span>
    % end
    {{title}}
</div>
<div id="grid">
    % for n, (k, entry) in enumerate(entries):
        <a href="{{base}}/{{k}}?collection={{collection}}&index={{n}}">
            <div class="entry" style="background-image: url('/thumb/{{k}}');">
                <div class="label{{''.join([' cat'+c for c in entry.categories])}}">{{entry.categories}} {{entry.name or ''}}</div>
            </div>
        </a>
    % end
</div>
% if entry is not None:
  <script language="javascript">
     $(document).keydown(function(e){
        var keyCode = e.keyCode || e.which;
        if (!e.ctrlKey && !e.altKey) {
            if (keyCode >= 65 && keyCode <= 90) { // letters A-Z
                e.preventDefault();
                $.ajax({
                    url: "/toggle:" + String.fromCharCode(keyCode) + "/{{collection}}",
                    type: 'PUT',
                    success: function(result) {
                        $("#cats").html(result);
                    }
                });
            }
        }
     });
  </script>
% end
