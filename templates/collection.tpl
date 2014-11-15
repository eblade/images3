% rebase('templates/base.tpl', title="Create Collection")
<div class="top">
    <a href="{{top}}">Back to the top</a>
</div>
<div class="title">Create collection</div>
% if created_link is not None:
    <a class="created_collection" href="{{created_link}}">Created {{created_name}}</a>
% end
<div class="form">
    <form method="POST" href="/collection:{{flt}}">
        <table>
            <tr>
                <td>Filename</td>
                <td><input name="filename" type="text" /></td>
            </tr>
            <tr>
                <td>Name</td>
                <td><input name="name" type="text" /></td>
            </tr>
            <tr>
                <td>Filter</td>
                <td><input name="filter" type="text" /></td>
            </tr>
            <tr>
                <td>Date (YYYYMMDD)</td>
                <td><input name="date" type="text" /></td>
            </tr>
            <tr>
                <td></td>
                <td><input type="submit" value="Create" /></td>
            </tr>
        </table>
    </form>
</div>
