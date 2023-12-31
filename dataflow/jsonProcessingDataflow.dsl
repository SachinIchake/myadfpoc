source(output(
		currentPage as boolean,
		data as (companyId as short, createdDate as string, deptFullCode as string, designation as string, desiredSkill as string, distributedChannels as string[], employeeJobDistribution as string, enabledForCareerSite as boolean, endtDate as string, id as short, jobCode as short, jobTitle as string, jobUrl as string, jobVisibiltyLevel as string, location as string, maxJobSalary as string, maxYrsOfExperience as string, minJobSalary as string, minYrsOfExperience as string, modifiedDate as string, positionsReq as boolean, privateJobShare as boolean, qualification as string, role as string, skillSet as string, skillsToEvaluate as string, startDate as string, status as boolean, vendorJobDistribution as (groupId as string, id as boolean, jobId as boolean, notified as boolean, profileValidity as string, userId as boolean, validityInDays as boolean, vendor as (added_date as string, companyId as boolean, creditConfig as string, email as string, endDate as string, id as boolean, isActive as boolean, isApproved as boolean, lastLoggedIn as string, partnerName as string, reason as string, sourceValidityConfigurationId as string, startDate as string, user as (companyId as boolean, competency as string, departmentalRoles as string, emailId as string, employeeId as string, id as boolean, isCandidateCredentialSent as boolean, isInterviewCredentialSent as string, issuperuser as boolean, linkedInProfile as string, logoutTime as string, modifiedByUserId as boolean, passwordReuseCount as boolean, phoneNo as string, roleId as boolean, status as boolean, subscribeToEmail as string, userDuplicateId as boolean, username as string, uuid as string), userId as boolean, vendorStatus as boolean), vendorAssignDate as string, vendorId as boolean, vendorName as string)[])[],
		pageSize as short,
		totalCount as short
	),
	allowSchemaDrift: true,
	validateSchema: false,
	ignoreNoFilesFound: false,
	documentForm: 'arrayOfDocuments') ~> datasource
datasource foldDown(unroll(data),
	mapColumn(
		parent_companyId = data.companyId,
		designation = data.designation,
		desiredSkill = data.desiredSkill,
		employeeJobDistribution = data.employeeJobDistribution,
		jobTitle = data.jobTitle,
		jobUrl = data.jobUrl,
		location = data.location,
		jobId = data.endtDate,
		vendorJobDistribution = data.vendorJobDistribution,
		distributedChannels = data.distributedChannels
	),
	skipDuplicateMapInputs: false,
	skipDuplicateMapOutputs: false) ~> flattendata
flattendata foldDown(unroll(vendorJobDistribution),
	mapColumn(
		jobId = vendorJobDistribution.jobId,
		vendor_companyId = vendorJobDistribution.vendor.companyId,
		partnerName = vendorJobDistribution.vendor.partnerName,
		vendorName = vendorJobDistribution.vendorName,
		designation,
		desiredSkill,
		location,
		distributedChannels,
		companyId = parent_companyId
	),
	skipDuplicateMapInputs: false,
	skipDuplicateMapOutputs: false) ~> flattenvendor
flattenvendor foldDown(unroll(distributedChannels),
	mapColumn(
		companyId,
		location,
		desiredSkill,
		designation,
		vendorName,
		partnerName,
		vendor_companyId,
		distributedChannels
	),
	skipDuplicateMapInputs: false,
	skipDuplicateMapOutputs: false) ~> flattenupdatewhitelist
flattenupdatewhitelist sink(allowSchemaDrift: true,
	validateSchema: false,
	deletable:false,
	insertable:true,
	updateable:false,
	upsertable:false,
	format: 'table',
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true,
	errorHandlingOption: 'stopOnFirstError',
	preCommands: [],
	postCommands: []) ~> sink1