<%@ tag display-name="javascript" description="Standard template for proctor pages" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- TODO: baseview model--%>
<%@ attribute name="useCompiledJavascript" required="false" type="java.lang.Boolean" %>
<%@ attribute name="compiledJavascriptSrc" required="false" type="java.lang.String" %>
<%@ attribute name="nonCompiledJavascriptSrc" required="false" type="java.lang.String" %>

<c:set var="req" value="${pageContext.request}" />
<c:set var="uri" value="${req.requestURI}" />
<c:set var="url">${req.requestURL}</c:set>

<script>
    (function(http) {
        var open = http.prototype.open;
        http.prototype.open = function interceptedOpen() {
            var args = Array.prototype.slice.call(arguments, 0),
                prefix = '${fn:substring(url, 0, fn:length(url) - fn:length(uri))}${req.contextPath}/',
                origin = location.protocol + '//' + location.host + '/',
                url = args[1];
            if (url.charAt(0) === '/') {
                url = prefix + url;
            } else if (url.indexOf(origin) === 0) {
                url = prefix + url.replace(origin, '');
            }
            args[1] = url;
            open.apply(this, args);
        };
    })(window.XMLHttpRequest);
</script>

<c:choose>
    <c:when test="${useCompiledJavascript}">
        <c:if test="${not empty compiledJavascriptSrc}">
            <script type="text/javascript" src="${compiledJavascriptSrc}"></script>
        </c:if>
    </c:when>
    <c:otherwise>
        <c:if test="${not empty nonCompiledJavascriptSrc}">
            <script type="text/javascript" src="${pageContext.request.contextPath}/static/scripts/closure-library/closure/goog/base.js"></script>
            <script type="text/javascript" src="${pageContext.request.contextPath}/static/scripts/app/deps.js"></script>
            <script type="text/javascript" src="${nonCompiledJavascriptSrc}"></script>
        </c:if>
    </c:otherwise>
</c:choose>
