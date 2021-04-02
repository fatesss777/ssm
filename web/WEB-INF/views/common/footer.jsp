<%--
  Created by IntelliJ IDEA.
  User: 54799
  Date: 2020/8/9
  Time: 19:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div id='PageLoadingTip' style="position: absolute; z-index: 1000; top: 0px; left: 0px; width: 100%; height: 100%; background: #f9f9f9; text-align: center; padding-top: 150px">
    <img src="../../../resources/admin/easyui/images/load-page.gif" >
    <h1 style="color:#15428B;">页面加载中···</h1>
</div>
</body>
<script type="text/javascript">
        function _PageLoadingTip_Closes() {
            $("#PageLoadingTip").fadeOut("normal", function () {
                $(this).remove();
            });
        }

        var _pageloding_pc;
        $.parser.onComplete = function () {
            if (_pageloding_pc) clearTimeout(_pageloding_pc);
            _pageloding_pc = setTimeout(_PageLoadingTip_Closes, 1000);
        }
</script>