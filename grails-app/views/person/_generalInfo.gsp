<div class="menu4">
	<ul>
		<li><a href="#" id="generalEditHeadId" class="mobmenu mobselect"
			onclick="switchTab(${person.id},'generalInfoEditId','generalEditHeadId')">General</a></li>
		<li><a href="#" id="availEditHeadId" class="mobmenu"
			onclick="switchTab(${person.id},'availabilityEditId','availEditHeadId')">Availability</a></li>
		<tds:hasPermission permission='EditTDSPerson'>
			<li><a href="#" id="tdsEditHeadId" class="mobmenu"
				onclick="switchTab(${person.id},'tdsUtilityEditId','tdsEditHeadId')">TDS</a></li>
		</tds:hasPermission>
	</ul>
</div>
<g:form name="personDialogForm" action="updatePerson">
	<div id="generalInfoEditId" class="person">
		<input type="hidden" name="id" value="${person.id}">
		<div class="dialog">
			<table class="personTable">
				<tbody>
					<tr class="prop">
						<td valign="top" class="name"><label for="firstName"><b>First
									Name:&nbsp;<span style="color: red">*</span>
							</b></label></td>
						<td valign="top" class="value" style="width: 40px"><input
							type="text" maxlength="64" id="firstNameId" name="firstName"
							value="${person.firstName}" size="10" /></td>
						<td rowspan="2"><g:if test="${person.personImageURL==null}">
								<img src="../images/blankPerson.jpg" alt="Smiley face"
									height="60" width="60">
							</g:if> <g:else>
								<img src="${person.personImageURL}" height="60" width="60">
							</g:else></td>
					</tr>

					<tr class="prop">
						<td valign="top" class="name"><label for="middleName">Middle
								Name:</label></td>
						<td valign="top" class="value" colspan="2" width="50%"><input
							type="text" maxlength="64" id="middleNameId" name="middleName"
							value="${person.middleName}" size="10" /></td>
					</tr>

					<tr class="prop">
						<td valign="top" class="name"><label for="lastName">Last
								Name:</label></td>
						<td valign="top" class="value" colspan="2" width="50%"><input
							type="text" maxlength="64" id="lastNameId" name="lastName"
							value="${person.lastName}" size="10" /></td>
					</tr>

					<tr class="prop">
						<td valign="top" class="name"><label for="company">Company:</label>
						</td>
						<td valign="top" class="value" colspan="2"><input type="text"
							maxlength="64" id="companyId" name="Company" value="${company}" />
						</td>
					</tr>

					<tr class="prop">
						<td valign="top" class="name"><label for="title">Title:</label>
						</td>
						<td valign="top" class="value" colspan="2"><input type="text"
							maxlength="34" id="titleId" name="title" value="${person.title}" />
						</td>
					</tr>
					<tr class="prop">
						<td valign="top" class="name"><label for="nickName">Email:</label>
						</td>
						<td valign="top" class="value" colspan="2"><input type="text"
							maxlength="64" id="emailId" name="email" value="${person.email}" />
						</td>
					</tr>
					<tr class="prop">
						<td valign="top" class="name"><label for="nickName">Image
								URL:</label></td>
						<td valign="top" class="value" colspan="2"><input type="text"
							id="personImageId" name="personImageURL"
							value="${person.personImageURL}" /></td>
					</tr>

					<tr class="prop">
						<td valign="top" class="name"><label for="nickName">Work
								Phone:</label></td>
						<td valign="top" class="value" colspan="2"><input type="text"
							maxlength="64" id="workPhoneId" name="workPhone"
							value="${person.workPhone}" /></td>
					</tr>

					<tr class="prop">
						<td valign="top" class="name"><label for="nickName">Mobile
								Phone:</label></td>
						<td valign="top" class="value" colspan="2"><input type="text"
							maxlength="64" id="mobilePhoneId" name="mobilePhone"
							value="${person.mobilePhone}" /></td>
					</tr>

					<tr class="prop">
						<td valign="top" class="name"><label for="nickName">City/State/Zip
								:</label></td>
						<td valign="top" class="value" colspan="2"><input type="text"
							maxlength="64" id="locationId" name="location"
							value="${person.location}" size="10" /> <input type="text"
							maxlength="64" id="stateProvId" name="stateProv"
							value="${person.stateProv}" size="4" /> <input type="text"
							maxlength="64" id="countryId" name="country"
							value="${person.country}" size="4" /></td>
					</tr>

					<tr class="prop">
						<td valign="top" class="name"><label for="nickName">Active
								:</label></td>
						<td valign="top" class="value" colspan="2"><g:select
								from="${Person.constraints.active.inList}" id="activeId"
								name="active" value="${person.active}" /></td>
					</tr>

					<tr class="prop">
						<td valign="top" class="name"><label>Team :</label></td>
						<td valign="top" class="value" colspan="2">
							<table style="border: 0px">
								<tbody id="funcsTbodyId">
									<g:each in="${personFunctions}" status="i" var="function">
										<tr id="funcTrId_${i}">
											<td><g:select from="${availabaleFunctions}" id="functionId"
													name="function" value="${function.id}" optionKey="id"
													optionValue="${{it.description}}"
													onChange="changeManageFuncs()" /> &nbsp;&nbsp; <a
												href="javascript:deleteFuncsRow('funcTrId_${i}')"><span
													class="clear_filter">X</span></a><br /></td>
										</tr>
									</g:each>
								</tbody>
							</table> <span style="cursor: pointer;" onclick="addFunctions()"><b>Add
									Team </b></span>
						</td>
					</tr>
				</tbody>

			</table>
			<input type="hidden" id="maxSize" value="${sizeOfassigned }">

			<input type="hidden" id="manageFuncsId" name="manageFuncs" value="0">


			<div id="availableFuncsId" style="display: none">
				<g:select from="${availabaleFunctions}" id="functionId" name="funcToAdd"
					optionValue="${{it.description}}"
					value="" optionKey="id" />
			</div>
		</div>

	</div>

	<div id="availabilityEditId" class="person" style="display: none;">
		<div>
			<script type="text/javascript" charset="utf-8">
	jQuery(function($){$('.dateRange').datepicker({showOn: 'both', buttonImage: '${resource(dir:'images',file:'calendar.gif')}', buttonImageOnly: true,beforeShow: customRange});function customRange(input) {return null;}});
	
	function showCalender(id){
		jQuery(function($){$(id).datepicker({showOn: 'both', buttonImage: '${resource(dir:'images',file:'calendar.gif')}', buttonImageOnly: true,beforeShow: customRange});function customRange(input) {return null;}});
}
</script>
			<table class="personTable" >
				<tbody id="blackOutDay">
					<tr>
						<td><span><b>Available , except for the following
									dates</b></span></td>
					</tr>
					<g:each in="${blackOutdays}" var="blackOutDay" status="i">
						<tr id="dateTrId_${i}">
							<td align="center"><input type="text" class="dateRange"
								size="15" style="width: 112px; height: 14px;"
								name="availability" id="availabilityId_${i}"
								value='<tds:convertDate date="${blackOutDay.exceptionDay}" timeZone="${request.getSession().getAttribute('CURR_TZ')?.CURR_TZ}"/>' />
								<a href="javascript:deleteFuncsRow('dateTrId_${i}')">&nbsp;&nbsp;<span
									class='clear_filter'>X</span></a></td>
						</tr>
					</g:each>
				</tbody>
			</table>
			<br /> <span id="" onclick="addBlackOutDay()"
				style="cursor: pointer;"><b> Add Date </b></span> <input
				type="hidden" id="availableId" value="1">

			<div id="dateDivId" style="display: none">
				<input type="text" size="15" style="width: 112px; height: 14px;"
					name="available" id="availId" />
			</div>
		</div>
	</div>

	<div id="tdsUtilityEditId" style="display: none;" class="person">
		<div class="dialog">
			<div class="dialog">
				<table class="personTable" >
					<tbody>
						<tr class="prop">
							<td valign="top" class="name"><label for="keyWords">KeyWords
									: </label></td>
							<td valign="top" class="value" ><input
								type="text" maxlength="64" id="keyWordsId" name="keyWords" size="40"
								value="${person.keyWords}" /></td>
						</tr>

						<tr class="prop">
							<td valign="top" class="name"><label for="tdsNote">TDS
									Note:</label></td>
							<td valign="top" class="value" colspan="2" ><input
								type="text" maxlength="64" id="tdsNoteId" name="tdsNote"
								value="${person.tdsNote}" size="40" /></td>
						</tr>

						<tr class="prop">
							<td valign="top" class="name"><label for="tdsLink">TDS
									Link</label></td>
							<td valign="top" class="value" colspan="2"><input
								type="text" id="tdsLinkId" name="tdsLink" size="40"
								value="${person.tdsLink}" /></td>
						</tr>

						<tr class="prop">
							<td valign="top" class="name"><label for="staffType ">StaffType
									:</label></td>
							<td valign="top" class="value" colspan="2"><g:select
									id="staffTypeId" name="staffType"
									from="${Person.constraints.staffType.inList}" value="Salary" />
							</td>
						</tr>

						<tr class="prop">
							<td valign="top" class="name"><label for="travleOK ">TravleOK
									:</label></td>
							<td valign="top" class="value" colspan="2"><input
								type="checkbox" id="travleOKId" name="travelOK"
								onclick="if(this.checked){this.value = 1} else {this.value = 0 }" ${person.travelOK == 1 ? 'checked="checked"' : 1 }
								value="${person.travelOK}" /></td>
						</tr>


					</tbody>

				</table>

			</div>
		</div>
	</div>
</g:form>
<tds:hasPermission permission='PersonEditView'>
<div class="buttons buttonsToUpdate">
	<input class="save" type="button" id="updateBId" value="Update"
		onClick="updatePerson('generalInfoShow','personDialogForm')" /> <input
		class="delete" type="button" id="cancelBId" value="Cancel"
		onClick="closePersonDiv('personGeneralViewId')" />
</div>
</tds:hasPermission>