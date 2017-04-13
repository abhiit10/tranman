<%@page import="com.tdsops.tm.enums.domain.AssetCommentStatus" %>
<%@page import="com.tds.asset.AssetComment" %>
<%@page import="com.tdssrc.grails.TimeUtil"%>
<%@page import="com.tdssrc.grails.HtmlUtil"%>
<g:set var="now" value="${TimeUtil.nowGMT()}" />
<%--
/*
 **************************
 * My Issues List 
 **************************
 */
--%>
<% java.text.DecimalFormat formatter = new java.text.DecimalFormat("0.0000") %>

<div id="myIssueList" class="mobbodyweb" style="width: 100%">
	<input id="issueId" name="issueId" type="hidden" value="" /> 
	<input name="tab" id="tabId" type="hidden" value="${tab}" />
	<div id="mydiv" onclick="this.style.display = 'none';setFocus();">
		<g:if test="${flash.message}">
			<br />
			<div class="message">
				<ul>
					${flash.message}
				</ul>
			</div>
		</g:if>
	</div>
	<div id="taskId" style="float: left; margin: 2px 0;"></div>
	<div id="assetIssueDiv" style="float: left; width: 100%;">
		<table id="issueTable" cellspacing="0px"
			style="width: 100%; margin-left: -1px;">
			<thead>
				<tr>
					<g:sortableColumn class="sort_column" style="" action="listTasks" property="number_comment" title="Task" params="['tab':tab,'search':search]"></g:sortableColumn>
					<g:sortableColumn class="sort_column" style="" action="listTasks" property="assetName" title="Related" params="['tab':tab,'search':search]"></g:sortableColumn>
					<g:sortableColumn class="sort_column" style="" action="listTasks" property="lastUpdated" title="Updated" params="['tab':tab,'search':search]"></g:sortableColumn>
					<g:sortableColumn class="sort_column" style="" action="listTasks" property="estFinish" title="Due/Est Finish" params="['tab':tab,'search':search]" defaultOrder="desc"></g:sortableColumn>
					<g:sortableColumn class="sort_column" style="" action="listTasks" property="status" title="Status" params="['tab':tab,'search':search]" defaultOrder="desc"></g:sortableColumn>
					<g:sortableColumn class="sort_column" style="" action="listTasks" property="assignedTo" title="Assigned To" params="['tab':tab,'search':search]" ></g:sortableColumn>
				</tr>
			</thead>
			<tbody>
				<g:each status="i" in="${taskList}" var="issue">
					<g:set var="item" value="${issue?.item}"/>
					<tr id="issueTrId_${item?.id}" class="${issue.css}" style="cursor: pointer;">
						<td id="comment_${item?.id}" class="actionBar asset_details_block_task"
							data-itemId="${item?.id}" data-status="${item?.status}">
							${item?.taskNumber?item?.taskNumber+' - ' : ''}
							${item?.comment}
						</td>
						<td id="asset_${item?.id}" class="asset_details_block"
						${item?.assetName ? 'onclick="getEntityDetails(\'myIssues\',\''+item?.assetType+'\',\''+item?.assetId+'\')"' : ''}>
							${item?.assetName} 
						</td>
						<td id="lastUpdated_${item?.id}" class="actionBar asset_details_block"
							data-itemId="${item?.id}" data-status="${item?.status}">
							<g:if test="${AssetComment.moveDayCategories.contains(item.category)}">
								<tds:elapsedAgo start="${item?.statusUpdated}" end="${now}"/>
							</g:if>
							<g:else>
								<tds:elapsedAgo start="${item?.lastUpdated}" end="${now}"/>
							</g:else>
						</td>
						<td id="estFinish_${item?.id}" data-itemId="${item?.id}" data-status="${item?.status}"
							class="actionBar asset_details_block ${item?.dueDate && item?.dueDate < TimeUtil.nowGMT() ? 'task_overdue' : ''}">
								<tds:convertDate date="${item?.estFinish}" timeZone="${request.getSession().getAttribute('CURR_TZ')?.CURR_TZ}"
									format="MM/dd kk:mm" />
						</td>
						
						<td id="statusTd_${item?.id}" class="actionBar asset_details_block"
							data-itemId="${item?.id}" data-status="${item?.status}">
							${item?.status}<% // (${formatter.format(item?.score?: 0)}) %>
						</td>
						<td id="assignedToName_${item?.id}" class="actionBar asset_details_block"
							data-itemId="${item?.id}" data-status="${item?.status}">
							${(item?.hardAssigned?'* ':'')} <span id="assignedToNameSpan_${item?.id}">${(item?.firstName?:'')+' '+((item?.lastName != null)? item?.lastName :'')}</span>
						</td>
					</tr>
					<tr id="showStatusId_${item?.id}" ${(todoSize!=1||search==''||search==null) ? 'style="display: none"' :''}>
						<td nowrap="nowrap" colspan="6" class="statusButtonBar">
							<g:if test="${issue.item.status == AssetCommentStatus.READY}"> 
							<tds:actionButton label="Start" icon="ui-icon-play" id="${item?.id}"  
								onclick="changeStatus('${item?.id}','${AssetCommentStatus.STARTED}', '${item?.status}', 'taskManager')"/>
							</g:if>
							<g:if test="${ [AssetCommentStatus.READY, AssetCommentStatus.STARTED].contains(issue.item.status) }"> 
							<tds:actionButton label="Done" icon="ui-icon-check" id="${item?.id}"  
								onclick="changeStatus('${item?.id}','${AssetCommentStatus.DONE}', '${item?.status}', 'taskManager')"/>
							</g:if>

							<tds:actionButton label="Details..." icon="ui-icon-zoomin" id="${item?.id}"  
								onclick="issueDetails(${item?.id},'${item?.status}')"/>

							<g:if test="${item.successors > 0 || item.predecessors > 0}">
								<tds:actionButton label="View Graph" icon="ui-icon-zoomin" id="${item?.id}"  
									onclick="window.open('${ HtmlUtil.createLink([controller:'task',action:'neighborhoodGraph', id: item?.id]) }','_blank');"  
								/>
							</g:if>
							<g:if test="${ personId != issue.item.assignedTo && issue.item.status in [AssetCommentStatus.PENDING, AssetCommentStatus.READY, AssetCommentStatus.STARTED]}">
							<tds:actionButton label="Assign To Me" icon="ui-icon-person" id="${item?.id}"  
								onclick="assignTask('${item?.id}','${issue.item.assignedTo}', '${issue.item.status}','myTask')"/>
							</g:if>
							<tds:hasPermission permission='CommentCrudView'>
								<g:if test="${issue.item.status == AssetCommentStatus.READY && !(item.category in AssetComment.moveDayCategories)}">
									<span class="delay_myTasks">Delay for:</span>
									<tds:actionButton label="1 day" icon="ui-icon-seek-next" id="${item?.id}"  
										onclick="changeEstTime(1,'${item?.id}', this.id)"/>
									<tds:actionButton label="2 days" icon="ui-icon-seek-next" id="${item?.id}"  
										onclick="changeEstTime(2,'${item?.id}', this.id)"/>
									<tds:actionButton label="7 days" icon="ui-icon-seek-next" id="${item?.id}"  
										onclick="changeEstTime(7,'${item?.id}', this.id)"/>
								</g:if>
							</tds:hasPermission>
						</td>
					</tr>

					<tr id="detailTdId_${item?.id}" style="display: none">
						<td colspan="6">
							<div id="detailId_${item?.id}" style="width: 100%"></div>
						</td>
					</tr>
				</g:each>
			</tbody>
		</table>
	</div>
</div>
<script type="text/javascript">
	if('${tab}'=="todo"){
		$("#toDOSpanId").html(${todoSize})
		$("#toDOAllSpanId").html(${allSize})
	}else{
		$("#allToDoSpanId").html(${todoSize})
		$("#allSpanId").html(${allSize})
	}
</script>
