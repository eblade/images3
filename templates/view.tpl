% rebase('templates/base.tpl', title=entry.filename)
  <div class="viewtitle {{''.join([' cat'+c for c in entry.categories])}}">
      % if prevpath is not None:
          <a href="{{base}}/{{prevpath}}">&lt;</a>
      % end
      <span id="cats">
      {{entry.categories}}
      </span>
      %# {{entry.filename}}
      % if prevpath is not None:
      <a href="{{base}}/{{nextpath}}">&gt;</a>
      % end
  </div>
  <center>
    <img style="height: {{height}}; width: {{width}};" src="/preview/{{entry.filename}}" />
  </center>
  <script language="javascript">
     $(document).keydown(function(e){
        var keyCode = e.keyCode || e.which;
        if (!e.ctrlKey && !e.altKey) {
            if (keyCode == 37) { // left
                % if prevpath is not None:
                    e.preventDefault();
                    window.location.href = "{{base}}/{{prevpath}}";
                % end
            } else if (keyCode == 39) { // right
                % if nextpath is not None:
                    e.preventDefault();
                    window.location.href = "{{base}}/{{nextpath}}";
                % end
            } else if (keyCode == 38) { // up
                % if nextpath is not None:
                    e.preventDefault();
                    window.location.href = "{{base}}/{{collection}}";
                % end
            } else if (keyCode >= 65 && keyCode <= 90) { // letters A-Z
                e.preventDefault();
                $.ajax({
                    url: "/toggle:" + String.fromCharCode(keyCode) + "/{{path}}",
                    type: 'PUT',
                    success: function(result) {
                        $("#cats").html(result);
                    }
                });
            } else if (keyCode == 13) { // enter
                e.preventDefault();
                window.location.href = "{{menu}}";
            }
        }
     });
  </script>


