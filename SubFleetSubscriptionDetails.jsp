<%@ page import="com.honeywell.bms.common.constants.BMSApplicationConstants"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-logic-el.tld" prefix="logic-el" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-bean-el.tld" prefix="bean-el" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-html-el.tld" prefix="html-el" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

<html:html locale="true" >
<html:base />
<title>Business Management System - Welcome Page</title>

<!-- STYLE SETTINGS -->
</head>
<!-- STYLE SETTINGS -->
<LINK REL=STYLESHEET TYPE='text/css' HREF="../css/style.css">
<!-- END OF STYLE SETTINGS -->
<script type="text/javascript" language="javascript1.2"	src="/BMSWeb/js/BMS_FormValidate.js"></script>
<script type="text/javascript" language="javascript1.2"	src="/BMSWeb/js/BMS_SUB_Common.js"></script>
<script type="text/javascript" language="javascript1.2"	src="/BMSWeb/js/BMS_Common.js"></script>
<script type="text/javascript" language="javascript1.2"	src="/BMSWeb/js/list.js"></script>
<script type="text/javascript" language="javascript1.2"	src="/BMSWeb/js/BMS_Customer_Ajax.js"></script>

<script type="text/javascript" language="javascript1.2">

var arStartCycle = new Array();
var arEndCycle = new Array();
var arSubDetCycle = new Array();
var vProductIdFldAr = new Array();
var vProductDescFldAr = new Array();
var vProductTypeFldAr = new Array();
var vProductTypeNameFldAr = new Array();
var vDbTypeFldAr = new Array();
var vMediaTypeFldAr = new Array();
var vAssociatedAr = new Array();//CR 166 UAT 3 Build 6
var vAssociatedDBValueAr = new Array();//CR 166 UAT 3 Build 6 
var vIsChildAr = new Array();//CR 166 UAT 3 Build 6
var vMediaFormatFldAr = new Array();//CR 150 UAT 3 BUild 6
var vDiscPercentFldAr = new Array();
var vDefShipQtyFldAr = new Array();
var vDiscAmtFldAr = new Array();
var vBillQtyFldAr = null;
var arBillingNeeded = new Array();
var arStatusSeq = new Array();
var arSaveYesNo = new Array()
var arObjStaticComboValues =  new Array();
var arRenTfrFlag =  new Array();
var arLatestShipmentCycleNum= new Array();
var arDataSupplier= new Array();
var arDataSupplierSeq= new Array();
var arProductType= new Array();
var arProductTypeName=new Array();
var vProductDataSupplierFldAr=new Array();
var vProductDataSupplierSeqFldAr=new Array();
var vDefaultMediaSeq = new Array();
var vDefaultLoadFormatId = new Array();
var vLoadableFormatFldAr = new Array();
var vRowNumberAr = new Array();

var vBillStatusSeqNew = '<%=BMSApplicationConstants.SUB_BILL_STATUS_NEW%>';
var vBillStatusSeqNoCharge = '<%=BMSApplicationConstants.SUB_BILL_STATUS_NOCHARGE%>';

var arMediaCatType = new Array();
<c:forEach items="${subSubscriptionDetailsForm.mediatypesList}" var="mediaDet" >
	arMediaCatType['<c:out value="${mediaDet.mediaTypeSequence}" />']='<c:out value="${mediaDet.mediaTypeCategory}" />';
</c:forEach>
	<c:forEach items="${subSubscriptionDetailsForm.dbProducts}" var="dbProdDet" >
    	<c:if test="${ dbProdDet.productStatus=='Y' }">
    	   arDataSupplier['<c:out value="${dbProdDet.dbProductID}" />']='<c:out value="${dbProdDet.dbProductDataSupplier}"/>'
    	</c:if>
    </c:forEach> 
    <c:forEach items="${subSubscriptionDetailsForm.dbProducts}" var="dbProdDet" >
    	<c:if test="${ dbProdDet.productStatus=='Y' }">
    	   arDataSupplierSeq['<c:out value="${dbProdDet.dbProductID}" />']='<c:out value="${dbProdDet.dbProductDataSupplierSeq}"/>'
    	</c:if>
    </c:forEach>

        <c:forEach items="${subSubscriptionDetailsForm.dbProducts}" var="dbProdDet" >
    	<c:if test="${ dbProdDet.productStatus=='Y' }">
    	  arProductType['<c:out value="${dbProdDet.dbProductID}" />']='<c:out value="${dbProdDet.productType}"/>'
    	</c:if>
 	</c:forEach> 
 	  <c:forEach items="${subSubscriptionDetailsForm.dbProducts}" var="dbProdDet" >
    	<c:if test="${ dbProdDet.productStatus=='Y' }">
    	  arProductTypeName['<c:out value="${dbProdDet.dbProductID}" />']='<c:out value="${dbProdDet.productTypeName}"/>'
    	</c:if>
 	</c:forEach> 
 	

function setFormMode(saveAndAdv)
{	
	/* reset the Product line before saving */
	
	 if(document.forms[0].subscripBillingStatus.value == 2){
	   if(saveAndAdv != 2)
	      alert("Please Regenerate the invoice to reflect the recent changes in invoice calculation");
	  }
	 
	var oldProductLineVal='<c:out value="${subSubscriptionDetailsForm.productLineSeq}" />';
	if( oldProductLineVal=='' )
		oldProductLineVal='-1';
	if( document.forms[0].productLineSeq.value!=oldProductLineVal )
	{
		alert("Product line selection will be reset to original value.");
		selectInBox(document.forms[0].productLineSeq.options,oldProductLineVal);
	}
	
	if(!checkSaveSubDetails('sub_fleet'))
	return ;
	if(!checkDetailCycles())
	return ;
	/*if(document.forms[0].detRequestType.value=='<%=BMSApplicationConstants.SUB_DETAILS_SAVE%>') 
	{	
		document.forms[0].detRequestType.value='<%=BMSApplicationConstants.SUB_DETAILS_EDIT%>' ;
	}*/	
	
	document.forms[0].addDel.value=""
	
	if( saveAndAdv == 1 )
		document.forms[0].saveAndAdvanceToShipDetailsTab.value="1"
	else if(saveAndAdv == 0)
		document.forms[0].saveAndAdvanceToShipDetailsTab.value="0"
	else
		document.forms[0].saveAndAdvanceToShipDetailsTab.value="2"
	
		<%-- clear the subscription details filter --%>
	document.forms[0].searchDbProductId.value="";
	document.forms[0].displayDbProductId.value="";
	
	document.forms[0].submit();
}

function selectProductLine()
{
	if( document.forms[0].productLineSeq.selectedIndex<1 )
	{
		alert("Please select a product line.");
		return;
	}
	// Pankaj start
	checkForAddDeleteCopyGo();
	// Pankaj end	
		<%-- clear the subscription details filter --%>
	document.forms[0].searchDbProductId.value="";
	document.forms[0].displayDbProductId.value="";
	
	document.forms[0].detRequestType.value='<%=BMSApplicationConstants.SUB_DETAILS_SELECT_PROD_LINE%>';
	document.forms[0].submit();
}

var  vProductIdAr = '<bean:write  name="subSubscriptionDetailsForm"  property="dbProdIDValues" />'.split('|');
var  vProductIdDescAr = '<bean:write name="subSubscriptionDetailsForm" property="dbProdIDDescValues" />'.split('|');
var  vProductIdTypeAr = '<bean:write name="subSubscriptionDetailsForm" property="dbProdIDTypeValues" />'.split('|');


function giveCredit(obj,detailSeq)
{
	var rowIdx = getRowIndex(obj)
	
	var vHidSubDetSeq = document.all.item('<%=BMSApplicationConstants.SUB_REQUEST_SUB_DETAIL_SEQ%>');
	
	vHidSubDetSeq.value = getObject(arSubDetCycle[rowIdx-1]).value;
	var vSubReqSeq = document.all.item('<%=BMSApplicationConstants.SUB_REQUEST_SUBSEQ%>').value;
	//var vSaveYesNo = getObject(arSaveYesNo[rowIdx-1]).value;
	var vSaveYesNo = '<bean:write  name="subSubscriptionDetailsForm"  property="popUpSaveYesNo" />';
	
	//alert('/BMSWeb/subscription/subNonDBBillingCredit.do?reqSubSeq='
	//			+vHidSubDetSeq.value+'&reqSubDetailSeq='+vSubReqSeq );
	
	window.open('/BMSWeb/subscription/subNonDBBillingCredit.do?reqSubSeq='+vSubReqSeq
				+'&reqSubDetailSeq='+vHidSubDetSeq.value+"&yesNoFlag="+vSaveYesNo,'Give_Credit', 'width=650,height=700,left=20,top=50,resizable=no');	
}


function resetFleetSubDetailsForm()
{
	resetForm();
	setAllDbProductDescriptions(vProductIdFldAr);
	loadMediaList();
}


function filterSubDetails()
{
	// Pankaj start
	checkForAddDeleteCopyGo();
	// Pankaj end
	document.forms[0].detRequestType.value='<%=BMSApplicationConstants.SUB_DETAILS_FILTER%>';
	document.forms[0].submit();
}

// On load this function gets all associated media for a detail based on Navdb. It loops through all the details
// and get the media details.
function loadMediaList()
{
	for (iloop = 0; iloop < vRowNumberAr.length; iloop++) {
		loop = vRowNumberAr[iloop];
		var newLoop = vRowNumberAr[iloop];
		if(document.getElementsByName("subDetailsList["+loop+"].dbProductId")){
			var navDbList =  document.getElementsByName("subDetailsList["+loop+"].dbProductId");
			var sNavDb =  navDbList[0].options[navDbList[0].selectedIndex].value;
			var subsDtlSeq = document.getElementsByName("subDetailsList["+loop+"].subcripDetailSeqNum")[0].value;
			var colonIndex = sNavDb.indexOf(":");
			if(colonIndex >= 0){
				sNavDb = sNavDb.substring(0,colonIndex);
			}
			autoPopulateMediaType(sNavDb,newLoop,iloop);
			delayedPopulateFormatType(newLoop, iloop);								
		}
	}
}

function delayedPopulateFormatType(loop, ArrayPosition)
{
	var navDbList =  document.getElementsByName("subDetailsList["+loop+"].dbProductId");
	var sNavDb =  navDbList[0].options[navDbList[0].selectedIndex].text;	
	
	var objMedia = document.getElementsByName("subDetailsList["+loop+"].mediaId");
	var sMediaSeq =  objMedia[0].options[objMedia[0].selectedIndex].value;
	 
	autoPopulateFormatType(sNavDb,null,sMediaSeq,loop, ArrayPosition);
}

// On change of Navdb, this function gets all associated media for a detail based on Navdb.
function onChangeLoadMediaList(sNavDb,position){
	
	var colonIndex = sNavDb.indexOf(":");
	if(colonIndex >= 0){
		sNavDb = sNavDb.substring(0,colonIndex);
	}
	autoPopulateMediaType(sNavDb,position,position);
	delayedPopulateFormatType(position, position);
}

// On change of Media, this function gets all associated format for a detail based on Navdb & Media.
function onChangeLoadFormatList(sMediaSeq,position){
	var subsDtlSeq = document.getElementsByName("subDetailsList["+position+"].subcripDetailSeqNum")[0].value;
	var navDbList =  document.getElementsByName("subDetailsList["+position+"].dbProductId");
	var sNavDb =  navDbList[0].options[navDbList[0].selectedIndex].text;
	autoPopulateFormatType(sNavDb,null,sMediaSeq,position, position);

}

function showDesc(sNavDb,position){
	var sDesc;
	for (i=0;i<vProductIdAr.length;i++) {
		if(vProductIdAr[i]==sNavDb){
			sDesc = vProductIdDescAr[i];
			break;
		}
	}
	//alert("i: "+i+ "Value: "+ vProductIdAr[i]+" Desc: "+sDesc);
	if(sDesc!= null && sDesc != ""){
		var sTable = "<table id='showDescTbl' border='1' align='left' style='position:absolute;' cellpadding='1' cellspacing='1' width='100px'>";
		sTable += "<tr class='searchresulttd' align='center'>";
		sTable += "<td > <Span><strong>"+sDesc+"</strong></span></td>";
		sTable += "<tr class='searchresulttd' align='center'>";
		sTable += "</table>";
		//alert("Show the box"+ sTable);
		document.getElementById("showDescDiv"+position).innerHTML = sTable;
		document.getElementById('showDescDiv'+position).style.visibility="visible";
	}
}
function hideDesc(position){
	document.getElementById('showDescDiv'+position).style.visibility="hidden";
}
</script>
<body topmargin="0" leftmargin="0" marginheight="0" marginwidth="0" onload="subdet_bodyOnLoad();setAllDbProductDescriptions(vProductIdFldAr);displayHoldPkslipBlock();saveandregnerate();loadMediaList();">
<jsp:include page="/inc/BMSHeader.jsp" flush="true"></jsp:include>
<jsp:include page="/inc/BMSMenu.jsp" flush="true"></jsp:include>
<html:form action="/subscription/subFleetSubscriptionDetails.do">

  <!-- CR 166 UAT 3 Build 6 start -->
  			    <c:forEach items="${subSubscriptionDetailsForm.associatedDataBaseList}" var="associatedDB">
	    		<script language="javascript">
	    			vAssociatedAr.push('<c:out value="${associatedDB}"/>');
	    		</script>
   			    </c:forEach>
  <!-- CR 166 UAT 3 Build 6 end-->
<!--table width="100%" border="0" class="breadcrumb" >
  <tr>
    <td height="9" ><bean:message key="subscription.common.header"/> :: <bean:message key="subscription.common.requirement" /> :: <%=session.getAttribute(BMSApplicationConstants.SUB_SESSION_OPMODE_VAR)%> Fleet-Based Requirements </td>  

  </tr>
</table-->
<table width="100%"  border="0">
  <tr>
    <td class="contentheading"><%=session.getAttribute(BMSApplicationConstants.SUB_SESSION_OPMODE_VAR)%> Requirements - Fleet Based: Subscription Details </td>
  </tr>
</table>
		<table width="100%" cellpadding="0" cellspacing="0" >
		<tr><td align="center">
		<table width="98%" cellpadding="0" cellspacing="0" >
		<tr><td class="AlertText"><html:errors bundle="bmserror" /></td></tr>
		
		<c:if test="${! empty FailedInvoices }" >
		<tr>
			<td class="AlertText">
				<bean:message bundle="bmserror" key="BMS_SUB_MESSAGE_0001" />
				<c:out value="${FailedInvoices}"/>
			</td>
		</tr>	
		</c:if>		
		
		</table>
		</td></tr>
		</table>
		<logic:messagesPresent message="true" > 
		<table width="100%" cellpadding="0" cellspacing="0" >
		<tr><td align="center">
		<table width="98%" cellpadding="0" cellspacing="0" >
		<tr><td class="AlertText"><html:messages id="message" message="true"  bundle="bmsapplication">
		<tr><td>
		<font class="AlertText"><b><bean:write name="message"/></b></font><br/>
		</td>
		</tr>
		</html:messages></td></tr>
		</table>
		</td></tr>
		</table> 
		</logic:messagesPresent>


<table width="100%"  border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td><table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td>
<table width="100%"  border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center"><table width="98%"  border="0">
      <tr>
        <td>          <table width="100%"  border="0">
          <tr >
            <td  height="2" class="subHeadingBar">&nbsp;</td>
          </tr>
        </table>
		<br>
          <table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="10%" class="formtxt">Customer Name : </td>
              <td width="40%" class="formtxt"><html:text property="customerName"  styleClass="autoFillFieldStyle"  size="45" readonly="true" /></td>
              <td width="10%" class="formtxt" >Service Type : </td> 
              <td width="40%" class="formtxt" ><html:text property="serviceType" styleClass="autoFillFieldStyle"  size="45" readonly="true" />              
            </tr>
          </table>
          <br>
          <table name="TabsMenu" id="TabMenuID" width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td nowrap width="1" background="/BMSWeb/images/tab_leftmost_off.gif"
					style="background-repeat: no-repeat">&nbsp;</td>
				<td name="BasicInfoTab" id="BInfoID" nowrap onmouseover="style.cursor='hand'" width="70" 
					background="/BMSWeb/images/tab_center_off.gif"
					align="center"
					onClick="setTargetLink('subFleetBasicInfo')"><font
					class="linkTextHeader">Basic Info</font></td>
				<td nowrap width="9" background="/BMSWeb/images/tab_rightmost_off.gif"
					style="background-repeat: no-repeat">&nbsp;</td>
				<td nowrap width="9" background="/BMSWeb/images/tab_leftmost_on.gif"
					style="background-repeat: no-repeat">&nbsp;</td>
				<td name="SubDetailsTab" id="SubDetailsID" nowrap  width="96" 
					background="/BMSWeb/images/tab_center_on.gif"
					align="center"><font
					class="linkTextHeader">Subscription Details</font></td>
				
				<td nowrap width="9" background="/BMSWeb/images/tab_rightmost_on.gif"
					style="background-repeat: no-repeat">&nbsp;</td>
				<td nowrap width="9" background="/BMSWeb/images/tab_leftmost_off.gif"
					style="background-repeat: no-repeat">&nbsp;</td>
				<td name="FleetDetailsTab" id="FleetDetailsID" nowrap onmouseover="style.cursor='hand'" width="77" 
					background="/BMSWeb/images/tab_center_off.gif"
					align="center"
					onClick="setTargetLink('subFleetFleetDetails')"><font
					class="linkTextHeader">Fleet Details</font></td>
				<td nowrap width="10" background="/BMSWeb/images/tab_rightmost_off.gif"
					style="background-repeat: no-repeat">&nbsp;</td>
				<!--td width="9" background="/BMSWeb/images/tab_leftmost_off.gif"
					style="background-repeat: no-repeat">&nbsp;</td>
				<td nowrap onmouseover="style.cursor='hand'" width="96" 
					background="/BMSWeb/images/tab_center_off.gif"
					align="center"
					onClick="setTargetLink('subFleetBillingDetails')"><font
					class="linkTextHeader">Billing Info</font></td>
				<td nowrap width="10" background="/BMSWeb/images/tab_rightmost_off.gif"
					style="background-repeat: no-repeat">&nbsp;</td-->
				<td nowrap width="9" background="/BMSWeb/images/tab_leftmost_off.gif"
					style="background-repeat: no-repeat">&nbsp;</td>
				<td name="ShipmentDetailsTab" id="ShipDetailsID" nowrap onmouseover="style.cursor='hand'" width="96" 
					background="/BMSWeb/images/tab_center_off.gif"
					align="center"
					onClick="setTargetLink('subFleetShipmentDetails')"><font
					class="linkTextHeader">Shipment Details</font></td>
				<td nowrap width="10" background="/BMSWeb/images/tab_rightmost_off.gif"
					style="background-repeat: no-repeat">&nbsp;</td>
				<td nowrap width="9" background="/BMSWeb/images/tab_leftmost_off.gif"
					style="background-repeat: no-repeat">&nbsp;</td>
				<td name="NotesTab" id="NotesID" nowrap onmouseover="style.cursor='hand'" width="77" 
					background="/BMSWeb/images/tab_center_off.gif"
					align="center"
					onClick="setTargetLink('subFleetTabNotes')""><font
					class="linkTextHeader">Notes</font></td>
				<td nowrap width="11" background="/BMSWeb/images/tab_rightmost_off.gif"
					style="background-repeat: no-repeat">&nbsp;</td>
				
	 
					<td colspan="15" nowrap align="right"> <span id="BlockPkSlipHolded" style="display:none">
			     	<font color="red" size="2" style="font-family: Arial, Helvetica, sans-serif">Packslip generation status:On hold</font></span></td>
	 				<td nowrap colspan="5" align="right">&nbsp;</td>
	 
				    <td nowrap align="right"
					style="color: #234B4B; font-family: Arial; font-size: 11px">
					<font class="TableTextAlert">*</font>
					<font color="#234B4B" size="1" style="font-family: Arial, Helvetica, sans-serif">Indicates mandatory fields</font>
					&nbsp;&nbsp;&nbsp;
					<font class="TableTextAlert">+</font>
					<font color="#234B4B" size="1" style="font-family: Arial, Helvetica, sans-serif">Indicates mandatory fields for database details</font>
				</td>
			</tr>
								</table>
          <table width="100%"  border="0" cellpadding="0" cellspacing="0">
            <tr class="tableHeader">
              <td width="13%" class="linkTextHeader" align="right"><a href="AddCustomerAddress.html"><font color="white"> </font></a> </td>
			  <td width="85%" class="linkTextHeader" >&nbsp; </td>
            </tr>
          </table>
          <br>
          
          <%-- code added for Product Line changes; START --%>
          <table width="100%" border="0" cellpadding="2">
          <tr class="headerData">
          	<td width="10%" class="formtxt">Product Line <font class="TableTextAlert">*</font> : </td>
          	<td width="35%">
          		<html:select styleClass="selectSmall" property="productLineSeq">
          			<html:option value="-1">--- Select ---</html:option>
          			<html:optionsCollection property="productLineMstList" label="codeDescription" value="code" />
          		</html:select>
          		&nbsp;
          		<a href="javascript:void(selectProductLine())" id="productLineSelectLink">
          		<img align="absmiddle"  src="/BMSWeb/images/but_go.gif" ></a>
          		
          		<script>
					arObjStaticComboValues['productLineSeq']='<c:out value="${subSubscriptionDetailsForm.productLineSeq}"/>'
				</script>
          	</td>
          	<td width="15%" class="formtxt">Search Database/Product : </td>
          	<td width="40%">
          		<html-el:select styleClass="selectSmall"  property="displayDbProductId" style="width:250" value="${subSubscriptionDetailsForm.searchDbProductId}" >
          			<html:option value="">-- All --</html:option>
          			<html:optionsCollection property="dbProducts" label="productDescription" value="productCode" />
          		</html-el:select>
          		&nbsp;
          		<a href="javascript:void(filterSubDetails())" >
          		<img align="absmiddle"  src="/BMSWeb/images/but_go.gif" ></a>
          		
          		<html:hidden property="searchDbProductId"/>
          	
          	</td>
          </tr>
          </table>
          <br>
          <%-- code added for Product Line changes; END --%>
          
          <table width="100%"  border="1" cellspacing="0" cellpadding="0" class="searchresulttable">
            <tr>
              <th width="5%" class="ResultTableHeader">Select</th>
              <th width="20%" class="ResultTableHeader">Database/Product Description <font class="TableTextAlert">*</font></th>
              <!--th width="7%" height="32" class="ResultTableHeader" style="text-align:center">Database/ Product ID</th-->
              <!--th width="9%" class="ResultTableHeader">Product Type </th-->
                <th width="7%" height="32" class="ResultTableHeader" style="text-align:center">Data Supplier </th>
              <th width="7%" height="32" class="ResultTableHeader" style="text-align:center">DB Type </th>
 			  <th width="8%" class="ResultTableHeader">Media Type <font class="TableTextAlert">+</font></th>
			  <th width="7%" class="ResultTableHeader">Loadable Format<font class="TableTextAlert">+</font></th>              
<!-- CR 150 UAT 3 BUild 6  next line added -->
              <th width="10%" class="ResultTableHeader">Delivery Type <font class="TableTextAlert">+</font></th>              
              <th width="9%" class="ResultTableHeader">Start Cycle <font class="TableTextAlert">*</font></th>
              <th width="9%" class="ResultTableHeader">End Cycle <font class="TableTextAlert">*</font></th>
              <th width="7%" class="ResultTableHeader">Discount Amount</th>
              <th width="8%" class="ResultTableHeader">Discount % </th>
              <th width="10%" class="ResultTableHeader">Ship Qty per cycle.</th>

              <th width="7%" class="ResultTableHeader">Billing Needed</th>
              <th width="9%" class="ResultTableHeader">Billing Status</th>
             <th width="8%" class="ResultTableHeader"> Renew </th>
              <TH width="4%" class="ResultTableHeader">Credit</TH>
            </tr>
            
            <c:forEach var="item1" varStatus="status1" items="${subSubscriptionDetailsForm.subDetailsList}"> 
   			<c:if test="${!item1.deletedFlag 
   							&& ( empty subSubscriptionDetailsForm.subDetailsList[status1.index].dbProductId
   								 || empty subSubscriptionDetailsForm.searchDbProductId 
   								 || subSubscriptionDetailsForm.searchDbProductId==subSubscriptionDetailsForm.subDetailsList[status1.index].dbProductId 
   								  ) 
   							}" >
   			<tr>   			
   				<td>
<!--CR 166 UAT 3 Build 6  start -->
                <table><tr> <td>  				
		        <html-el:hidden property="subDetailsList[${status1.index}].isChild" />	
              	<script language="javascript">
   					vIsChildAr.push('<c:out value="subDetailsList[${status1.index}].isChild"/>');
   					vRowNumberAr.push('<c:out value="${status1.index}"/>');
   				</script>
		        </td><td>
		        <html-el:hidden property="subDetailsList[${status1.index}].associatedDBValue" />
				        	        														   				
              	<script language="javascript">
   					vAssociatedDBValueAr.push('<c:out value="subDetailsList[${status1.index}].associatedDBValue"/>');
   				</script>
   				</td>
		        </tr></table>                                                                                                    
   					<c:if test ="${subSubscriptionDetailsForm.subDetailsList[status1.index].isChild=='Y'}">
   					<input type="checkbox" name="CheckDelete" onClick="MarkForDelete(this,'MarkDelete')" disabled ="disabled"/>
   					</c:if>
   					<c:if test ="${subSubscriptionDetailsForm.subDetailsList[status1.index].isChild=='N'}">
   					<input type="checkbox" name="CheckDelete" onClick="MarkForDelete(this,'MarkDelete')" />
   					</c:if>   					
					<input type="hidden" name="MarkDelete" />					
<!--CR 166 UAT 3 Build 6 end -->
				</td>
   				 <td  class="formtxt">
   				 <!--CR 166 UAT 3 Build 6 start -->
   					<c:if test ="${subSubscriptionDetailsForm.subDetailsList[status1.index].isChild=='Y' || subSubscriptionDetailsForm.subDetailsList[status1.index].associatedDBValue!='NA'}">   				 
   				<html-el:select styleClass="selectSmall" disabled="true" property="subDetailsList[${status1.index}].dbProductId" style="width:200" onmouseout="hideDesc(${status1.index})" onmouseover="showDesc(this.options[this.selectedIndex].value,${status1.index})" onchange="setCorrespondingValues(this, ${status1.index}),onChangeLoadMediaList(this.options[this.selectedIndex].value,${status1.index})" >   
				    <html:option value="">--Select-- </html:option>
				    <logic:notEmpty name="subSubscriptionDetailsForm" property="dbProducts">
				    <%--html:optionsCollection property="dbProducts" value="productCode" label="dbProductID"/--%>
				    <%--html:optionsCollection property="dbProducts" value="productCode" label="productDescription"/--%>
				    <c:forEach items="${subSubscriptionDetailsForm.dbProducts}" var="dbProdDet" >
				    	<c:if test="${ dbProdDet.productStatus=='Y' || dbProdDet.productCode==subSubscriptionDetailsForm.subDetailsList[status1.index].dbProductId }">
				    	   <html-el:option value="${dbProdDet.productCode}" ><c:out value="${dbProdDet.productDescription}"/></html-el:option>
				    	</c:if>
				    </c:forEach>
				    </logic:notEmpty>
	    		</html-el:select>
	    		</c:if>
	    		<c:if test ="${subSubscriptionDetailsForm.subDetailsList[status1.index].isChild=='N' && subSubscriptionDetailsForm.subDetailsList[status1.index].associatedDBValue=='NA'}">
   				<html-el:select styleClass="selectSmall" property="subDetailsList[${status1.index}].dbProductId" style="width:200" onmouseout="hideDesc(${status1.index})" onmouseover="showDesc(this.options[this.selectedIndex].value,${status1.index})" onchange="setCorrespondingValues(this, ${status1.index}),onChangeLoadMediaList(this.options[this.selectedIndex].value,${status1.index})" >   
				    <html:option value="">--Select-- </html:option>
				    <logic:notEmpty name="subSubscriptionDetailsForm" property="dbProducts">
				    <%--html:optionsCollection property="dbProducts" value="productCode" label="dbProductID"/--%>
				    <%--html:optionsCollection property="dbProducts" value="productCode" label="productDescription"/--%>
				    <c:forEach items="${subSubscriptionDetailsForm.dbProducts}" var="dbProdDet" >
				    	<c:if test="${ dbProdDet.productStatus=='Y' || dbProdDet.productCode==subSubscriptionDetailsForm.subDetailsList[status1.index].dbProductId }">
				    	   <html-el:option value="${dbProdDet.productCode}" ><c:out value="${dbProdDet.productDescription}"/></html-el:option>
				    	</c:if>
				    </c:forEach>
				    </logic:notEmpty>
				    <c:if test ="${subSubscriptionDetailsForm.subDetailsList[status1.index].makeReadOnly=='true' }">
	    			<script language="javascript">
	    			makeOneDisabled('<c:out value="subDetailsList[${status1.index}].dbProductId"/>','true');
	    			</script>
	    			</c:if> 
			   		
	    		</html-el:select>   				
	    		</c:if>
	    		<script language="javascript">
	   				vProductIdFldAr.push('<c:out value="subDetailsList[${status1.index}].dbProductId"/>');
	   				vProductTypeFldAr.push('<c:out value="subDetailsList[${status1.index}].productType"/>');
	   				vProductDescFldAr.push('<c:out value="subDetailsList[${status1.index}].productDBDesc"/>');
   				</script>
   				<span id='showDescDiv<c:out value="${status1.index}"/>'/>
   				</td>		
                <%--td>
              	<html-el:text property="subDetailsList[${status1.index}].productDBDesc"	value="${subSubscriptionDetailsForm.subDetailsList[status1.index].dbProductIdForDisplay}" readonly="true" size="10" styleClass="input"/>
              	<script language="javascript">
   				vProductDescFldAr.push('<c:out value="subDetailsList[${status1.index}].productDBDesc"/>');
   			</script>
			  	<html-el:hidden property="subDetailsList[${status1.index}].productType"  />
				
			  	<script language="javascript">
   				vProductTypeFldAr.push('<c:out value="subDetailsList[${status1.index}].productType"/>');
   			</script>
			  </td--%>	
			  <td>
			     <html-el:text property="subDetailsList[${status1.index}].dbSupplier"	styleClass="input" readonly="true" size="5" />
             	<html-el:hidden property="subDetailsList[${status1.index}].dbSupplierSeq"  />
             	<script language="javascript">
             	
   					vProductDataSupplierSeqFldAr.push('<c:out value="subDetailsList[${status1.index}].dbSupplierSeq"/>');
   					vProductDataSupplierFldAr.push('<c:out value="subDetailsList[${status1.index}].dbSupplier"/>');
   				</script>
           	
			  </td>
			       <td>
			     <html-el:text property="subDetailsList[${status1.index}].productTypeName"	styleClass="input" readonly="true" size="5" />
             	
             	<script language="javascript">
             	
   					vProductTypeNameFldAr.push('<c:out value="subDetailsList[${status1.index}].productTypeName"/>');
   					
   				</script>
           	
			  </td>
              <td><span class="formtxt">
              			<bean:define id="MediaStatusActive" value="<%= BMSApplicationConstants.MEDIA_TYPE_STATUS_ACTIVE %>"></bean:define>
<!-- CR 150 UAT 3 BUild 6  adding on change for the below drop down  -->              			
                <html-el:select styleClass="selectMediaFit" property="subDetailsList[${status1.index}].mediaId" onchange="onChangeLoadFormatList(this.options[this.selectedIndex].value,${status1.index})">
   			    <html:option value="">--Select--</html:option>              	              	                
   			    <c:forEach items="${subSubscriptionDetailsForm.mediatypesList}" var="mediaTypeDet">
   			  <c:if test="${mediaTypeDet.mediaStatusId==MediaStatusActive || mediaTypeDet.mediaTypeSequence==subSubscriptionDetailsForm.subDetailsList[status1.index].mediaId }">
   			    	<html-el:option value="${mediaTypeDet.mediaTypeSequence}"><c:out value="${mediaTypeDet.description}"/></html-el:option>
   			  </c:if>
   			    </c:forEach>
			    
					<c:if test ="${subSubscriptionDetailsForm.subDetailsList[status1.index].makeReadOnly=='true' }">
	    			<script language="javascript">
	    			makeOneDisabled('<c:out value="subDetailsList[${status1.index}].mediaId"/>','true');
	    			</script>
	    			</c:if> 	
	    		</html-el:select>
	    		<script language="javascript">
	    			vMediaTypeFldAr.push('<c:out value="subDetailsList[${status1.index}].mediaId"/>');
	    			vDefaultMediaSeq .push('<c:out value="${subSubscriptionDetailsForm.subDetailsList[status1.index].mediaId}"/>');
	    		</script>
              </span></td>
              <!-- Loadable Format -->
              <td>
				<html-el:select styleClass="selectMediaFit" property="subDetailsList[${status1.index}].loadFormatId">  
	   			    <html:option value="">--Select--</html:option>              	              	
	    		</html-el:select>
	    		<script language="javascript">
	    			vLoadableFormatFldAr.push('<c:out value="subDetailsList[${status1.index}].loadFormatId"/>');
	    			vDefaultLoadFormatId .push('<c:out value="${subSubscriptionDetailsForm.subDetailsList[status1.index].loadFormatId}"/>');
	    		</script>         
              </td>              
              <!-- CR 150 UAT 3 BUild 6 start   -->
			  <td><span class="formtxt">
			  		<bean:define id="MediaStatusActiveFormat" value="<%= BMSApplicationConstants.MEDIA_TYPE_STATUS_ACTIVE %>"></bean:define>
                <html-el:select styleClass="selectSmaller" property="subDetailsList[${status1.index}].mediaFormatId">   
   			    <html:option value="">--Select--</html:option>              	              	
   			    <c:forEach items="${subSubscriptionDetailsForm.mediaformatsList}" var="mediaFormatDet">
   			    <c:if test="${mediaFormatDet.mediaStatusId==MediaStatusActiveFormat || mediaFormatDet.mediaTypeSequence==subSubscriptionDetailsForm.subDetailsList[status1.index].mediaFormatId }">
   			    	<html-el:option value="${mediaFormatDet.mediaTypeSequence}"><c:out value="${mediaFormatDet.description}"/></html-el:option>
   			    </c:if>
   			    </c:forEach>
			<%--	<c:if test="${!empty subSubscriptionDetailsForm.mediatypesList}">                
				    <html:optionsCollection name="subSubscriptionDetailsForm" 
					   property="mediatypesList" label="description" value="mediaTypeSequence"/>					   
				</c:if>	   
			--%>	
					
				
					<c:if test ="${subSubscriptionDetailsForm.subDetailsList[status1.index].makeReadOnly=='true' }">
	    			<script language="javascript">

	    			makeOneDisabled('<c:out value="subDetailsList[${status1.index}].mediaFormatId"/>','true');
	    			</script>
	    			</c:if> 	
	    		</html-el:select>
	    		<script language="javascript">
	    			vMediaFormatFldAr.push('<c:out value="subDetailsList[${status1.index}].mediaFormatId"/>');
	    		</script>
              </span></td>              
              <!-- CR 150 UAT 3 BUild 6 end   -->               
              <td>
              	<html-el:select styleClass="selectCycleFit" property="subDetailsList[${status1.index}].startCycle">   
	    		
	                     <c:if test ="${subSubscriptionDetailsForm.subDetailsList[status1.index].makeReadOnly=='true' }">
	    			<script language="javascript">
	    			makeOneDisabled('<c:out value="subDetailsList[${status1.index}].startCycle"/>','true');
	    			</script>
	    			</c:if>  
                        <script language="javascript">
	    			arStartCycle.push('<c:out value="subDetailsList[${status1.index}].startCycle"/>');
	                        arLatestShipmentCycleNum.push('<c:out value="subDetailsList[${status1.index}].latestShipmentCycleNum"/>');
	    		
	    		</script>
              	
			    <html-el:option value="">--Select--</html-el:option>
			    <logic:notEmpty name="subSubscriptionDetailsForm" property="cycleSpan">              	
				    <html:optionsCollection name="subSubscriptionDetailsForm" 
					   property="cycleSpan" label="cycleNumber" value="cycleNumber"/>					   
			    </logic:notEmpty>					   
	    		</html-el:select>
  			  <html-el:hidden property= "subDetailsList[${status1.index}].saveButtonYesNo" />	    		
		       <html-el:hidden property="subDetailsList[${status1.index}].fleetDiscAppFlag" />   
		       <html-el:hidden property="subDetailsList[${status1.index}].fleetDiscAppFlagDesc"   />	              
  			  
			  </td>
			  <td>
              	<html-el:select styleClass="selectCycleFit" property="subDetailsList[${status1.index}].endCycle">   
			    <html:option value="">--Select-- </html:option>              	
			<c:if test="${!empty subSubscriptionDetailsForm.cycleSpan}">
				
				
				<c:forEach items="${subSubscriptionDetailsForm.cycleSpan}" var="cycleList">
				<c:choose>
				<c:when test="${ subSubscriptionDetailsForm.subDetailsList[status1.index].latestShipmentCycleNum!=null }">
				 
						  <c:if test="${ cycleList.cycleNumber >=subSubscriptionDetailsForm.subDetailsList[status1.index].latestShipmentCycleNum }">
				    	  <html-el:option value="${cycleList.cycleNumber}"><c:out value="${cycleList.cycleNumber}"/></html-el:option>
						  </c:if>
				</c:when>
				<c:otherwise>
				   	   	 <html-el:option value="${cycleList.cycleNumber}"><c:out value="${cycleList.cycleNumber}"/></html-el:option>
   				</c:otherwise>
   				</c:choose>
   			    </c:forEach>						   
				</c:if>	 	   
	    		</html-el:select>	
	    		<script language="javascript">
	    				arEndCycle.push('<c:out value="subDetailsList[${status1.index}].endCycle"/>');
	    		</script>
	  </td>	
			  <td>
              	<html-el:text property="subDetailsList[${status1.index}].discountAmt"  size="5" maxlength="18" styleClass="input"/> 	
				<script language="javascript">
	    			vDiscAmtFldAr.push('<c:out value="subDetailsList[${status1.index}].discountAmt"/>');
	    		</script>											
              </td>
			  <td>
		        <html-el:text property="subDetailsList[${status1.index}].discountPer"					
						size="3" maxlength="8"  styleClass="input"/>
				<script language="javascript">
	    			vDiscPercentFldAr.push('<c:out value="subDetailsList[${status1.index}].discountPer"/>');
	    		</script>	
	    		
	    			
			  </td>
              <td>
		        <html-el:text property="subDetailsList[${status1.index}].defaultShipQty" styleClass="input"	
						size="4" maxlength="5" />
			
	<c:if test ="${subSubscriptionDetailsForm.subDetailsList[status1.index].makeReadOnly=='true' }">
	    			<script language="javascript">
	    			makeOneReadOnly('<c:out value="subDetailsList[${status1.index}].defaultShipQty"/>','true');
	    			</script>
	    			</c:if> 
	<script language="javascript">
	    			vDefShipQtyFldAr.push('<c:out value="subDetailsList[${status1.index}].defaultShipQty"/>');
	    		</script>				
			  </td>    
 
			  
			  <bean:define id="billStatusSeqNew" value="<%=String.valueOf(BMSApplicationConstants.SUB_BILL_STATUS_NEW)%>"></bean:define>
			  <c:choose>		
			    <c:when test="${item1.subcripDetailSeqNum == null || empty item1.subcripDetailSeqNum ||item1.subcripDetailSeqNum ==0.0 || item1.billStatusChanged}">
			  <TD>
              	<html-el:select style="width:50" styleClass="selectSmall" property="subDetailsList[${status1.index}].billingNeeded" onchange="setBillStatusSeq(this)">   
				<html:option value="Y">Yes</html:option>
				<html:option value="N">No</html:option>
				</html-el:select>			  
			  </TD>
			  
    			<td>

              	<html-el:select styleClass="selectSmall" property="subDetailsList[${status1.index}].billStatusSeq" onchange="setBillNeeded(this)">   
			                   	
				    <html-el:optionsCollection 
				    		   property="subDetailsList[${status1.index}].billStatusForCreate" label="value" value="key" />					   
	    		</html-el:select>

	    		</td>	
			    
			    </c:when>
			  	  
			  <c:when test="${item1.billStatusSeq==billStatusSeqNew && item1.subcripDetailSeqNum != '' }">
			  <TD>
              	<html-el:select style="width:50" styleClass="selectSmall" property="subDetailsList[${status1.index}].billingNeeded" onchange="setBillStatusSeq(this)">   
				<html:option value="Y">Yes</html:option>
				<html:option value="N">No</html:option>
				</html-el:select>			  
			  </TD>
			  
    			<td>

              	<html-el:select styleClass="selectSmall" property="subDetailsList[${status1.index}].billStatusSeq" onchange="setBillNeeded(this)">   
			                   	
				    <html-el:optionsCollection 
				    		   property="subDetailsList[${status1.index}].billStatusForCreate" label="value" value="key" />					   
	    		</html-el:select>

	    		</td>	
			  </c:when>
			  <c:otherwise>
			  <td class="formtxt">
			   <c:choose>	
			  	<c:when test="${item1.billingNeeded=='Y' && item1.subcripDetailSeqNum != '' }">
			  	<span class="formtxt"> <c:out value="Yes"/> </span>
			  	</c:when>
			    <c:otherwise>
			  	<span class="formtxt"> <c:out value="No"/> </span>	
			  	</c:otherwise>
			    </c:choose>
			    <html-el:hidden property="subDetailsList[${status1.index}].billingNeeded" />
			  </td>
			  <td class="formtxt">
			  <span class="formtxt"> <c:out value="${item1.billStatusDesc}"/>&nbsp;</span>
			  <html-el:hidden property="subDetailsList[${status1.index}].billStatusSeq" />
			  </td>
			  </c:otherwise>
			  </c:choose>
			  <script language="javascript">
			  arStatusSeq.push('<c:out value="subDetailsList[${status1.index}].billStatusSeq"/>');
			  arBillingNeeded.push('<c:out value="subDetailsList[${status1.index}].billingNeeded"/>');			  
			  arSaveYesNo.push('<c:out value="subDetailsList[${status1.index}].saveButtonYesNo" />');
			  </script>
		  <TD>
              	<html-el:select styleClass="selectSmall" property="subDetailsList[${status1.index}].renTfrFlag" onchange="setRenTfrFlag(this);setRenEndCycle(this)" style="width:50px">   
				<html:option value="Y" >Yes</html:option>	
				<html:option value="N" >No</html:option>										
				</html-el:select>			  
			  </TD>     
			  
			  	<c:if test="${item1.billingNeeded=='N'}">
					<script language="javascript">
						
							makeOneReadOnly('<c:out value="subDetailsList[${status1.index}].discountAmt"/>','true');
							makeOneReadOnly('<c:out value="subDetailsList[${status1.index}].discountPer"/>','true');
				
				
				   </script>	
				   </c:if>
			  <script language="javascript">
			  arRenTfrFlag.push('<c:out value="subDetailsList[${status1.index}].renTfrFlag"/>');
			 
			  </script>                      
		
			  <td class="formtxt">			  
				<c:choose>
					<c:when test="${item1.linkYesNo=='Y'}" >	              
					<image src="/BMSWeb/images/icon_edit.gif" class="normalLink" onmouseover="style.cursor='hand'" onclick="giveCredit(this,'<c:out value="${item1.subcripDetailSeqNum}" />')">
					</c:when>
					<c:otherwise>
					<image src="/BMSWeb/images/icon_edit.gif" class="normalLink" onclick="alert('Credit information is not available. Subscription billing status is not in paid status.')">
					</c:otherwise>
			  	</c:choose>			  
			  </td>			  
			    	<html-el:hidden property="subDetailsList[${status1.index}].latestShipmentCycleNum"	/>
				<html-el:hidden property="subDetailsList[${status1.index}].subcripDetailSeqNum"	/>
				<script language="javascript">
				arSubDetCycle.push('<c:out value="subDetailsList[${status1.index}].subcripDetailSeqNum"/>')
				</script>
            </tr> 
            </c:if> <%-- If condition to check for deleted items --%>           
       		</c:forEach>
       		<!--Subscription Level Data -->       		
				<html:hidden name="subSubscriptionDetailsForm" property="fleetDiscAppFlag"	/>
				<html:hidden name="subSubscriptionDetailsForm" property="fleetDiscAppFlagDesc"	/>
				<html:hidden name="subSubscriptionDetailsForm" property="subscripStartCycle"	/>				
				<html:hidden name="subSubscriptionDetailsForm" property="subscripEndCycle"	/>       		
       		<tr>
              <td colspan="12" align="left" class="blacksmall">
              		<a href="javascript:void(doCopySubDetRow('<%=BMSApplicationConstants.SUB_DETAILS_COPY %>'))"><SPAN class="normalLink">Copy Row</SPAN></a>&nbsp;&nbsp;|&nbsp;
              		<a href="javascript:void(doAddDelete('<%=BMSApplicationConstants.SUB_DETAILS_ADD%>'))"><SPAN class="normalLink">Add Row</SPAN></a>&nbsp;&nbsp;|&nbsp;
              <!--/td>
              <td -->
              		<a href="javascript:void(doAddDelete('<%=BMSApplicationConstants.SUB_DETAILS_DELETE%>'))"><SPAN class="normalLink">Delete</SPAN></a>
              </td>
            </tr>
          </table>
          
          <table width="100%">
          	<tr>
          	<td><font color="#234B4B"	size="1" style="font-family: Arial, Helvetica, sans-serif">
          		* <bean:message key="subscription.deletedisclaimer.subscriptiondetails" bundle="bmsapplication"/>	
          	    </font>
          	</td>
          	 </tr>
          	 <tr>
          	<td>
          	<font color="#234B4B"	size="1" style="font-family: Arial, Helvetica, sans-serif">
          		* Please update the Fleet details appropriately when Database is added/deleted/updated in Subscription details	
          	    </font>
          	</td>
          	</tr>
       
          </table>

		  <br>
          <table width="100%"  border="0" cellpadding="0" cellspacing="0">
            <tr class="tableHeader">
              <td id="divSave"  width="83%" class="linkTextHeader" align="left">
              	<table cellpadding="0" cellspacing="0" width="100%" >
              	<tr>
              		<td width="30%" align="left">
	              	<a href="javascript:void(setFormMode(true))">
	              	<b><img src="/BMSWeb/images/but_Save&Advance.gif" ></b></a>
              		</td>
              		<td width="25%" align="center">
	              	<a href="javascript:void(setFormMode(false))">
	              	<b><img src="/BMSWeb/images/but_save.gif" ></b></a>
              		</td>
              		 <td width="15%" align="left">
              	    <span id="regenerateblock" style="display:block">
	              	<a href="javascript:void(setFormMode(2))">
	              	<b><img src="/BMSWeb/images/but_save_regenerte_inv.gif" ></b></a>
	              	</span>
              		</td>
                    <td width="30%" align="right">
	                <a href="javascript:void(setFormMode(true))">
	                <b><img src="/BMSWeb/images/but_Save&Advance.gif" ></b></a>
                    </td>              		
              	</tr>
              	</table>
              </td>
              <td width="17%" class="linkTextHeader" ><div align="right"><font color="white">
              	<a href="javascript:void(history.go(-1))">
              	<img src="/BMSWeb/images/but_cancel.gif" ></a>
              	<a href="javascript:void(resetFleetSubDetailsForm())">
              	<img src="/BMSWeb/images/but_reset.gif" ></a>
              	</font></div></td>
            </tr>
          </table>  <br>
        </td>
      </tr>
    </table></td>
  </tr>
</table>
	<html:hidden  property="holdPkSlip" />
<input type="hidden" name="detRequestType" value="<%=request.getAttribute("detRequestType")%>" />
<input type="hidden" name="<%=BMSApplicationConstants.SUB_REQUEST_SUB_DETAIL_SEQ%>" />
<input type="hidden" name="DBsToBeCopied" value=""/> <!-- CR 166 UAT 3 Build 6 -->
<html:hidden property="subscripBillingStatus" />

<!--Mandatory hidden fields to be present and to be forwarded to all the other screens  Starts -->
<jsp:include page="subFleetCommonInc.jsp" flush="true"></jsp:include>
<jsp:include page="subCommonInc.jsp" flush="true"></jsp:include>
<!-- Mandatory Fields Ends -->

<html:hidden property="addDel" />
</html:form>
<!-- FOOTER STARTS HERE  -->
<jsp:include page="/inc/BMSFooter.jsp" flush="true"></jsp:include>
<!-- FOOTER ENDS HERE -->
</body>
</html:html>
<script>
//setTimeout("loadMediaList()",500);



  function saveandregnerate()
   {
		
	 				    
      if(document.forms[0].subscripBillingStatus.value == 2){
            document.getElementById('regenerateblock').style.display='block';
      }
      else{
            document.getElementById('regenerateblock').style.display='none'; 
       }
  }

</script>


