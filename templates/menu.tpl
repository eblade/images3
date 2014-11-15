% rebase('templates/base.tpl', title=key)
  <div class="viewtitle">
      Menu for {{key}}
  </div>
  <div class="menu_thumb">
      <a href="{{base}}/{{key}}{{query}}">
          <div class="entry" style="background-image: url('/thumb/{{key}}');">
              <div class="label{{''.join([' cat'+c for c in entry.categories])}}">{{entry.categories}} {{entry.name or ''}}</div>
          </div>
      </a>
  </div>
  <div class="menu">
    <b>Add to collection</b>
    <div class="list">
        % for n, (k, collection) in enumerate(collections):
            <a class="listitem" href="#" onclick='add_to("{{k}}");'>
                % if n < 9:
                    #{{(n+1)}}
                % elif n == 9:
                    #0
                % end
                {{collection.name}}
            </a><br/>
        % end
    </div>
  </div>
  <script language="javascript">
     function add_to(target) {
        $.ajax({
            url: "/append/"+target+"?entry={{key}}",
            type: 'POST',
            success: function(result) {
                alert(result)
            }
        });
     }

     $(document).keydown(function(e){
        var keyCode = e.keyCode || e.which;
        if (!e.ctrlKey && !e.altKey) {
            % if len(collections) > 0:
                 if (keyCode == 49) { e.preventDefault(); add_to("{{collections[0][0]}}"); }
            % end
            % if len(collections) > 1:
            else if (keyCode == 50) { e.preventDefault(); add_to("{{collections[1][0]}}"); }
            % end
            % if len(collections) > 2:
            else if (keyCode == 51) { e.preventDefault(); add_to("{{collections[2][0]}}"); }
            % end
            % if len(collections) > 3:
            else if (keyCode == 52) { e.preventDefault(); add_to("{{collections[3][0]}}"); }
            % end
            % if len(collections) > 4:
            else if (keyCode == 53) { e.preventDefault(); add_to("{{collections[4][0]}}"); }
            % end
            % if len(collections) > 5:
            else if (keyCode == 54) { e.preventDefault(); add_to("{{collections[5][0]}}"); }
            % end
            % if len(collections) > 6:
            else if (keyCode == 55) { e.preventDefault(); add_to("{{collections[6][0]}}"); }
            % end
            % if len(collections) > 7:
            else if (keyCode == 56) { e.preventDefault(); add_to("{{collections[7][0]}}"); }
            % end
            % if len(collections) > 8:
            else if (keyCode == 57) { e.preventDefault(); add_to("{{collections[8][0]}}"); }
            % end
            % if len(collections) > 9:
            else if (keyCode == 48) { e.preventDefault(); add_to("{{collections[9][0]}}"); }
            % end
        }
     });
  </script>


