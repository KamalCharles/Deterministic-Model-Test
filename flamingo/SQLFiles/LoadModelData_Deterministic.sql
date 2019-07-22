



------------------------------------------
--Deterministic Model
------------------------------------------

Declare @ReleaseDate date = getdate()
Declare @ModelName nvarchar(255)			= 'Deterministic Model'
Declare @VersionRef nvarchar(255)			= '1.0.0'
Declare @ModelDescription nvarchar(255)		= 'Deterministic Model'
Declare @MidTierIP nvarchar(255)			= '10.10.0.163'
Declare @MidTierPort int					= 9003
Declare @KeysServiceURL nvarchar(255)		= 'http://10.10.0.163:9010/Oasis/Deterministic/get_keys'
Declare @ModelGroupField nvarchar(255)		= 'LocID'
Declare @ModelVersionID nvarchar(255)		= 'Deterministic'
Declare @ModuleSupplierName nvarchar(255)	= 'Oasis'
Declare @ModelPerilName1 nvarchar(255)		= 'WTC'
Declare @ModelPerilDescription1 nvarchar(255)= 'Wind'

-----------------------
--OED Transforms
-----------------------
Declare @TransformNameLocOED nvarchar(255)	= 'Deterministic Source To Can'
Declare @TransformNameAccOED nvarchar(255)	= 'Deterministic Can To Model' 
Declare @ProfileNameLocOED nvarchar(255)	= 'Deterministic Loc'
Declare @ProfileNameAccOED nvarchar(255)	= 'Deterministic Acc'

Declare @FromLocXSDFileOED nvarchar(255)	= 'Deterministic_CanAccA.xsd'
Declare @ToLocAXSDFileOED nvarchar(255)		= 'Deterministic_CanAccA.xsd'
Declare @ToLocBXSDFileOED nvarchar(255)		= 'Deterministic_CanAccA.xsd'
Declare @ToModelXSDFileOED nvarchar(255)	= 'Deterministic_CanAccA.xsd'
Declare @FromAccXSDFileOED nvarchar(255)	= 'Deterministic_CanAccA.xsd'
Declare @ToAccAXSDFileOED nvarchar(255)		= 'Deterministic_CanAccA.xsd'
Declare @ToAccBXSDFileOED nvarchar(255)		= 'Deterministic_CanAccA.xsd'

Declare @XSLTLocFileOED nvarchar(255)		= 'MappingMapToDeterministic_CanLocA.xslt'
Declare @XSLTModelFileOED nvarchar(255)		= 'MappingMapToDeterministic_ModelLoc.xslt'
Declare @XSLTAccFileOED nvarchar(255)		= 'MappingMapToDeterministic_CanAccA.xslt'


-----------------------
--Model Meta Data
-----------------------
--delete model if exists
Declare @timestamp nvarchar(255) = (select convert(varchar, getdate(), 120))
update model set ModelName = 'XXX - ' + ModelName + ' - deleted ' + @timestamp, deleted = 1  where ModelName = @ModelName

Declare	@SupplierId int = (Select ISNULL(Max(SupplierId),0) + 1 From Supplier)
Declare	@ModelFamilyId int = (Select ISNULL(Max(ModelFamilyId),0) + 1 From ModelFamily)
Declare	@ModelId int = (Select ISNULL(Max(ModelId),0) + 1 From Model)
Declare	@ServiceId int = (Select ISNULL(Max(ServiceId),0) + 1 From Service)
Declare	@OasisSystemId int = (Select ISNULL(Max(OasisSystemId),0) + 1 From OasisSystem)
Declare	@OasisSystemServiceId int = (Select ISNULL(Max(OasisSystemServiceId),0) + 1 From OasisSystemService)
Declare	@ModelResourceId int = (Select ISNULL(Max(ModelResourceId),0) From ModelResource)
Declare	@ModelPerilId int = (Select ISNULL(Max(ModelPerilId),0) From ModelPeril)
Declare	@ModelCoverageTypeId int = (Select ISNULL(Max(ModelCoverageTypeId),0) From ModelCoverageType)

Declare	@ModelLicenseId int = (Select ISNULL(Max(ModelLicenseId),0) + 1 From ModelLicense)
Declare	@OasisUserId int = (Select ISNULL(Max(OasisUserId),0) + 1 From OasisUser) --to be fixed
Declare	@UserLicenseId int = (Select ISNULL(Max(UserLicenseId),0) + 1 From UserLicense)

Declare	@ResourceId int = (Select ISNULL(Max(ResourceId),0) + 1 From [Resource])
Declare	@FileId int = (Select ISNULL(Max(FileId),0) + 1 From [File])
Declare	@TransformId int = (Select ISNULL(Max(TransformId),0) + 1 From [Transform])
Declare	@FileResourceId int = (Select ISNULL(Max(FileResourceId),0) + 1 From [FileResource])
Declare @ProfileResourceId int = (Select ISNULL(Max(ProfileResourceId),0) + 1 From [ProfileResource])
Declare @ProfileId int = (Select ISNULL(Max(ProfileId),0) + 1 From [Profile])
Declare @ProfileElementId int = (Select ISNULL(Max(ProfileElementId),0) From [ProfileElement])
Declare @ProfileValueDetailID int = (Select ISNULL(Max(ProfileValueDetailID),0) + 1 From [ProfileValueDetail])

Declare @int int
Declare @int2 int


--Supplier
INSERT [dbo].[Supplier] ([SupplierID], [SupplierName], [SupplierDesc], [SupplierLegalName], [SupplierAddress], [SupplierPostcode], [SupplierTelNo], [Deleted]) 
		VALUES (@SupplierId,N'',N'',N'',N'',N'',N'',0)

--ModelFamily
INSERT [dbo].[ModelFamily] ([ModelFamilyID], [ModelFamilyName], [SupplierID]) 
		VALUES (@ModelFamilyId, N'', @SupplierId)

--Model
INSERT [dbo].[Model] ([ModelID], [ModelName], [ModelFamilyID], [ModelDescription], [VersionRef], [ReleaseDate], [Contact], [ModelTypeId], [Deleted]) 
		VALUES (@ModelId, @ModelName, @ModelFamilyId, @ModelDescription,@VersionRef, @ReleaseDate, N'Frank Lavelle', 2, 0)

--Service
INSERT [dbo].[Service] ([ServiceID], [ServiceName], [ServiceDesc], [ServiceTypeId], [ModelId]) 
		VALUES (@ServiceId, N'Oasis', N'Oasis Mid Tier', 1, @ModelId)
INSERT [dbo].[Service] ([ServiceID], [ServiceName], [ServiceDesc], [ServiceTypeId], [ModelId])
		VALUES (@ServiceId+1, N'API', N'Oasis Key Lookup Service', 2, @ModelId)

--OasisSystem
INSERT [dbo].[OasisSystem] ([OasisSystemID], [OasisSystemName], [OasisSystemDescription], [url], [Port], [SysConfigID]) 
		VALUES (@OasisSystemId, N'Oasis Mid Tier', N'Oasis Mid Tier', @MidTierIP, @MidTierPort, 4)
INSERT [dbo].[OasisSystem] ([OasisSystemID], [OasisSystemName], [OasisSystemDescription], [url], [Port], [SysConfigID])
		VALUES (@OasisSystemId+1, N'API', N'Lookup Service', @KeysServiceURL, NULL, NULL)

--OasisSystemService
INSERT [dbo].[OasisSystemService] ([OasisSystemServiceID], [OasisSystemID], [ServiceID]) 
		VALUES (@OasisSystemServiceId, @OasisSystemId, @ServiceId)
INSERT [dbo].[OasisSystemService] ([OasisSystemServiceID], [OasisSystemID], [ServiceID]) 
		VALUES (@OasisSystemServiceId+1, @OasisSystemId+1, @ServiceId+1)

--ModelResource
Create Table #ModelResource
		(
		ModelResourceId int identity,
		ModelResourceName nvarchar(255),
		ResourceTypeID int,
		OasisSystemID int,
		ModelID int,
		ModelResourceValue nvarchar(255),
		)

INSERT #ModelResource (ModelResourceName,ResourceTypeID,OasisSystemID,ModelID,ModelResourceValue) VALUES (N'model_file_extension', 305, @OasisSystemID+1, @ModelID, N'csv')
INSERT #ModelResource (ModelResourceName,ResourceTypeID,OasisSystemID,ModelID,ModelResourceValue) VALUES (N'API', 1000, @OasisSystemID+1, @ModelID, N'')
INSERT #ModelResource (ModelResourceName,ResourceTypeID,OasisSystemID,ModelID,ModelResourceValue) VALUES (N'ModelGroupField', 300, @OasisSystemID, @ModelID, @ModelGroupField)
INSERT #ModelResource (ModelResourceName,ResourceTypeID,OasisSystemID,ModelID,ModelResourceValue) VALUES (N'module_supplier_id', 301, @OasisSystemID, @ModelID, @ModuleSupplierName)
INSERT #ModelResource (ModelResourceName,ResourceTypeID,OasisSystemID,ModelID,ModelResourceValue) VALUES (N'model_version_id', 302, @OasisSystemID, @ModelID, @ModelVersionID)


INSERT	[dbo].[ModelResource] ([ModelResourceID], [ModelResourceName], [ResourceTypeID], [OasisSystemID], [ModelID], [ModelResourceValue])
SELECT	[ModelResourceID] + @ModelResourceId as [ModelResourceID],
		[ModelResourceName],
		[ResourceTypeID],
		[OasisSystemID],
		[ModelID],
		[ModelResourceValue]
FROM	#ModelResource

DROP TABLE #ModelResource

--ModelLicense
INSERT [dbo].[ModelLicense] ([ModelLicenseID], [ModelID], [CompanyID], [ModelLicenseName], [ModelVersionDescription], [LicenseStartDate], [LicenseEndDate], [LicenseType], [LicenseContractRef]) 
		VALUES (@ModelLicenseId, @ModelId, 1, N'', N'', '01/01/1900', '12/31/9999', 'Dummy License', '')

--OasisUser
INSERT [dbo].[OasisUser] ([OasisUserID], [OasisUserName], [ModelLicenseID], [OasisSystemID], [SystemLogin], [SystemPassword], [Django Login], [Django Password]) 
		VALUES (@OasisUserId, N'OasisUser', @ModelLicenseId, @OasisSystemId, N'Root', N'Password', N'', N'')

--UserLicense
INSERT [dbo].[UserLicense] ([UserLicenseId], [BFEUserID], [OasisUserID]) VALUES (@UserLicenseId, 1, @OasisUserId)

--ModelPeril
INSERT ModelPeril Values (@ModelPerilId+1, @ModelId,1, @ModelPerilName1, @ModelPerilDescription1)

--ModelCoverageType			
INSERT ModelCoverageType Values (@ModelCoverageTypeId+1,@ModelId,1,'1','Buildings')
INSERT ModelCoverageType Values (@ModelCoverageTypeId+2,@ModelId,2,'2','Other Structures')
INSERT ModelCoverageType Values (@ModelCoverageTypeId+3,@ModelId,3,'3','Contents')
INSERT ModelCoverageType Values (@ModelCoverageTypeId+4,@ModelId,4,'4','Business Interuption')

---------------------------------------------------------
--Transforms
---------------------------------------------------------


---------------------------------------------------------
--Transforms
---------------------------------------------------------
--update names if exist
update [profile] set ProfileName = 'XXX - ' + ProfileName + ' - deleted ' + @timestamp where ProfileName = @ProfileNameLocOED
update [profile] set ProfileName = 'XXX - ' + ProfileName + ' - deleted ' + @timestamp where ProfileName = @ProfileNameAccOED

update transform set TransformName = 'XXX - ' + TransformName + ' - deleted ' + @timestamp where TransformName = @TransformNameLocOED
update transform set TransformName = 'XXX - ' + TransformName + ' - deleted ' + @timestamp where TransformName = @TransformNameAccOED

---------------------------------------------------
--EDM
---------------------------------------------------

--Params
Set	@ResourceId = (Select ISNULL(Max(ResourceId),0) + 1 From [Resource])
Set	@FileId = (Select ISNULL(Max(FileId),0) + 1 From [File])
Set	@FileResourceId = (Select ISNULL(Max(FileResourceId),0) + 1 From [FileResource])
Set	@TransformId = (Select ISNULL(Max(TransformId),0) + 1 From [Transform])
Set	@ProfileId = (Select ISNULL(Max(ProfileId),0) + 1 From [Profile])

--Loc
--
-- |XSD1|-->|XSLT1|-->|XSD2a|
--                       |
--                       V
--                    |XSD2b|-->|XSLT2|-->|XSD3|
--                       |
--                       V
--                   |Profile1|
--Acc
--
-- |XSD4|-->|XSLT3|-->|XSD5a|
--                       |
--                       V
--                    |XSD5b|
--                       |
--                       V
--                   |Profile2|

--Declare Resource IDs
Declare @FromLocXSDResourceID		int = @ResourceId + 0  -- XSD1
Declare @XSLTLocResourceID			int = @ResourceId + 1  -- XSLT1
Declare @ToLocAXSDResourceID		int = @ResourceId + 2  -- XSD2a
Declare @ToLocBXSDResourceID		int = @ResourceId + 3  -- XSD2b
Declare @FromModelXSDResourceID		int = @ResourceId + 4  -- XSLT2
Declare @XSLTModelResourceID		int = @ResourceId + 5  -- XSLT2
Declare @ToModelXSDResourceID		int = @ResourceId + 6  -- XSD3
Declare @LocProfileResourceID		int = @ResourceId + 7  -- Profile1
Declare @FromAccXSDResourceID		int = @ResourceId + 8  -- XSD4
Declare @XSLTAccResourceID			int = @ResourceId + 9  -- XSLT3
Declare @ToAccAXSDResourceID		int = @ResourceId + 10 -- XSD5a
Declare @ToAccBXSDResourceID		int = @ResourceId + 11 -- XSD5b
Declare @AccProfileResourceID		int = @ResourceId + 12 -- Profile2

--Declare File IDs
Declare @FromLocXSDFileID			int = @FileId + 0  -- XSD1
Declare @XSLTLocFileID				int = @FileId + 1  -- XSLT1
Declare @ToLocAXSDFileID			int = @FileId + 2  -- XSD2a
Declare @ToLocBXSDFileID			int = @FileId + 3  -- XSD2b
Declare @XSLTModelFileID			int = @FileId + 4  -- XSLT2
Declare @ToModelXSDFileID			int = @FileId + 5  -- XSD3
Declare @FromAccXSDFileID			int = @FileId + 6  -- XSD4
Declare @XSLTAccFileID				int = @FileId + 7  -- XSLT3
Declare @ToAccAXSDFileID			int = @FileId + 8  -- XSD5a
Declare @ToAccBXSDFileID			int = @FileId + 9  -- XSD5b

--Declare File Resource IDs
Declare @FromLocXSDFileResourceID	int = @FileResourceId + 0  -- XSD1
Declare @XSLTLocFileResourceID		int = @FileResourceId + 1  -- XSLT1
Declare @ToLocAXSDFileResourceID	int = @FileResourceId + 2  -- XSD2a
Declare @ToLocBXSDFileResourceID	int = @FileResourceId + 3  -- XSD2b
Declare @FromModelXSDFileResourceID int = @FileResourceId + 4  -- XSD2b
Declare @XSLTModelFileResourceID	int = @FileResourceId + 5  -- XSLT2
Declare @ToModelXSDFileResourceID	int = @FileResourceId + 6  -- XSD3
Declare @FromAccXSDFileResourceID	int = @FileResourceId + 7  -- XSD4
Declare @XSLTAccFileResourceID		int = @FileResourceId + 8  -- XSLT3
Declare @ToAccAXSDFileResourceID	int = @FileResourceId + 9  -- XSD5a
Declare @ToAccBXSDFileResourceID	int = @FileResourceId + 10 -- XSD5b

--Declare Profile IDs
Declare @LocProfileId int = @ProfileID     -- Profile1
Declare @AccProfileId int = @ProfileID + 1 -- Profile2

-------------insert data------------------------


---------------------------------------------------
--OED
---------------------------------------------------

--Params
Set	@ResourceId = (Select ISNULL(Max(ResourceId),0) + 1 From [Resource])
Set	@FileId = (Select ISNULL(Max(FileId),0) + 1 From [File])
Set	@FileResourceId = (Select ISNULL(Max(FileResourceId),0) + 1 From [FileResource])
Set	@TransformId = (Select ISNULL(Max(TransformId),0) + 1 From [Transform])
Set	@ProfileId = (Select ISNULL(Max(ProfileId),0) + 1 From [Profile])

Set @ProfileResourceId = (Select ISNULL(Max(ProfileResourceId),0) + 1 From [ProfileResource])
Set @ProfileId = (Select ISNULL(Max(ProfileId),0) + 1 From [Profile])
Set @ProfileElementId = (Select ISNULL(Max(ProfileElementId),0) From [ProfileElement])
Set @ProfileValueDetailID = (Select ISNULL(Max(ProfileValueDetailID),0) + 1 From [ProfileValueDetail])

--Loc
--
-- |XSD1|-->|XSLT1|-->|XSD2a|
--                       |
--                       V
--                    |XSD2b|-->|XSLT2|-->|XSD3|
--                       |
--                       V
--                   |Profile1|
--Acc
--
-- |XSD4|-->|XSLT3|-->|XSD5a|
--                       |
--                    |XSD5b|
--                       |
--                       V
--                   |Profile2|

--Declare Resource IDs
Set @FromLocXSDResourceID		 = @ResourceId + 0  -- XSD1
Set @XSLTLocResourceID			 = @ResourceId + 1  -- XSLT1
Set @ToLocAXSDResourceID		 = @ResourceId + 2  -- XSD2a
Set @ToLocBXSDResourceID		 = @ResourceId + 3  -- XSD2b
Set @FromModelXSDResourceID		 = @ResourceId + 4  -- XSLT2
Set @XSLTModelResourceID		 = @ResourceId + 5  -- XSLT2
Set @ToModelXSDResourceID		 = @ResourceId + 6  -- XSD3
Set @LocProfileResourceID		 = @ResourceId + 7  -- Profile1
Set @FromAccXSDResourceID		 = @ResourceId + 8  -- XSD4
Set @XSLTAccResourceID			 = @ResourceId + 9  -- XSLT3
Set @ToAccAXSDResourceID		 = @ResourceId + 10 -- XSD5a
Set @ToAccBXSDResourceID		 = @ResourceId + 11 -- XSD5b
Set @AccProfileResourceID		 = @ResourceId + 12 -- Profile2

--Declare File IDs
Set @FromLocXSDFileID			 = @FileId + 0  -- XSD1
Set @XSLTLocFileID				 = @FileId + 1  -- XSLT1
Set @ToLocAXSDFileID			 = @FileId + 2  -- XSD2a
Set @ToLocBXSDFileID			 = @FileId + 3  -- XSD2b
Set @XSLTModelFileID			 = @FileId + 4  -- XSLT2
Set @ToModelXSDFileID			 = @FileId + 5  -- XSD3
Set @FromAccXSDFileID			 = @FileId + 6  -- XSD4
Set @XSLTAccFileID				 = @FileId + 7  -- XSLT3
Set @ToAccAXSDFileID			 = @FileId + 8  -- XSD5a
Set @ToAccBXSDFileID			 = @FileId + 9  -- XSD5b

--Declare File Resource IDs
Set @FromLocXSDFileResourceID	 = @FileResourceId + 0  -- XSD1
Set @XSLTLocFileResourceID		 = @FileResourceId + 1  -- XSLT1
Set @ToLocAXSDFileResourceID	 = @FileResourceId + 2  -- XSD2a
Set @ToLocBXSDFileResourceID	 = @FileResourceId + 3  -- XSD2b
Set @FromModelXSDFileResourceID  = @FileResourceId + 4  -- XSD2b
Set @XSLTModelFileResourceID	 = @FileResourceId + 5  -- XSLT2
Set @ToModelXSDFileResourceID	 = @FileResourceId + 6  -- XSD3
Set @FromAccXSDFileResourceID	 = @FileResourceId + 7  -- XSD4
Set @XSLTAccFileResourceID		 = @FileResourceId + 8  -- XSLT3
Set @ToAccAXSDFileResourceID	 = @FileResourceId + 9  -- XSD5a
Set @ToAccBXSDFileResourceID	 = @FileResourceId + 10 -- XSD5b

--Declare Profile IDs
Set @LocProfileId  = @ProfileID     -- Profile1
Set @AccProfileId  = @ProfileID + 1 -- Profile2

-------------insert data------------------------
--Transform
Insert Into Transform Values (@TransformId,@TransformNameLocOED,@TransformNameLocOED,1)
Insert Into Transform Values (@TransformId+1,@TransformNameAccOED,@TransformNameLocOED,2)

--ModelTransform
INSERT ModelTransform Values (@ModelId,@TransformId,'OED')
INSERT ModelTransform Values (@ModelId,@TransformId+1,'OED')

--Resource
INSERT [dbo].[Resource] ([ResourceId], [ResourceTable], [ResourceKey], [ResourceQualifier], [ResourceTypeID]) VALUES (@FromLocXSDResourceID,	'Transform',@TransformId,NULL,120)
INSERT [dbo].[Resource] ([ResourceId], [ResourceTable], [ResourceKey], [ResourceQualifier], [ResourceTypeID]) VALUES (@XSLTLocResourceID,		'Transform',@TransformId,NULL,124)
INSERT [dbo].[Resource] ([ResourceId], [ResourceTable], [ResourceKey], [ResourceQualifier], [ResourceTypeID]) VALUES (@ToLocAXSDResourceID,		'Transform',@TransformId,NULL,121)
INSERT [dbo].[Resource] ([ResourceId], [ResourceTable], [ResourceKey], [ResourceQualifier], [ResourceTypeID]) VALUES (@ToLocBXSDResourceID,		'Transform',@TransformId,NULL,129)
INSERT [dbo].[Resource] ([ResourceId], [ResourceTable], [ResourceKey], [ResourceQualifier], [ResourceTypeID]) VALUES (@FromModelXSDResourceID,	'Transform',@TransformId+1,NULL,120)
INSERT [dbo].[Resource] ([ResourceId], [ResourceTable], [ResourceKey], [ResourceQualifier], [ResourceTypeID]) VALUES (@XSLTModelResourceID,		'Transform',@TransformId+1,NULL,124)
INSERT [dbo].[Resource] ([ResourceId], [ResourceTable], [ResourceKey], [ResourceQualifier], [ResourceTypeID]) VALUES (@ToModelXSDResourceID,	'Transform',@TransformId+1,NULL,121)
INSERT [dbo].[Resource] ([ResourceId], [ResourceTable], [ResourceKey], [ResourceQualifier], [ResourceTypeID]) VALUES (@LocProfileResourceID,	'Transform',@TransformId,NULL,118)
INSERT [dbo].[Resource] ([ResourceId], [ResourceTable], [ResourceKey], [ResourceQualifier], [ResourceTypeID]) VALUES (@FromAccXSDResourceID,	'Transform',@TransformId,NULL,122)
INSERT [dbo].[Resource] ([ResourceId], [ResourceTable], [ResourceKey], [ResourceQualifier], [ResourceTypeID]) VALUES (@XSLTAccResourceID,		'Transform',@TransformId,NULL,125)
INSERT [dbo].[Resource] ([ResourceId], [ResourceTable], [ResourceKey], [ResourceQualifier], [ResourceTypeID]) VALUES (@ToAccAXSDResourceID,		'Transform',@TransformId,NULL,123)
INSERT [dbo].[Resource] ([ResourceId], [ResourceTable], [ResourceKey], [ResourceQualifier], [ResourceTypeID]) VALUES (@ToAccBXSDResourceID,		'Transform',@TransformId,NULL,130)
INSERT [dbo].[Resource] ([ResourceId], [ResourceTable], [ResourceKey], [ResourceQualifier], [ResourceTypeID]) VALUES (@AccProfileResourceID,	'Transform',@TransformId,NULL,119)

--File
INSERT [dbo].[File] ([FileId], [FileName], [FileDesc], [SourceID], [OwnerID], [LocationID], [DateTimeCreated], [DateTimeUpdated], [DateTimeDeleted], [OwnerNameCreated], [OwnerNameUpdated], [OwnerNameDeleted], [FileTypeId]) VALUES (@FromLocXSDFileID,@FromLocXSDFileOED, N'Source Loc Validation File', 1, 1, 106, getdate(), getdate(), NULL, N'Sys', N'Sys', NULL, 109) --XSD1
INSERT [dbo].[File] ([FileId], [FileName], [FileDesc], [SourceID], [OwnerID], [LocationID], [DateTimeCreated], [DateTimeUpdated], [DateTimeDeleted], [OwnerNameCreated], [OwnerNameUpdated], [OwnerNameDeleted], [FileTypeId]) VALUES (@XSLTLocFileID,@XSLTLocFileOED, N'Source to Canonical Loc Tranformation File', 1, 1, 105, getdate(), getdate(), NULL, N'Sys', N'Sys', NULL, 110) --XSLT1
INSERT [dbo].[File] ([FileId], [FileName], [FileDesc], [SourceID], [OwnerID], [LocationID], [DateTimeCreated], [DateTimeUpdated], [DateTimeDeleted], [OwnerNameCreated], [OwnerNameUpdated], [OwnerNameDeleted], [FileTypeId]) VALUES (@ToLocAXSDFileID,@ToLocAXSDFileOED, N'Canonical Loc Validation File', 1, 1, 106, getdate(), getdate(), NULL, N'Sys', N'Sys', NULL, 109) --XSD2a
INSERT [dbo].[File] ([FileId], [FileName], [FileDesc], [SourceID], [OwnerID], [LocationID], [DateTimeCreated], [DateTimeUpdated], [DateTimeDeleted], [OwnerNameCreated], [OwnerNameUpdated], [OwnerNameDeleted], [FileTypeId]) VALUES (@ToLocBXSDFileID,@ToLocBXSDFileOED, N'Canonical Loc Profile File', 1, 1, 106, getdate(), getdate(), NULL, N'Sys', N'Sys', NULL, 109) --XSD2b
INSERT [dbo].[File] ([FileId], [FileName], [FileDesc], [SourceID], [OwnerID], [LocationID], [DateTimeCreated], [DateTimeUpdated], [DateTimeDeleted], [OwnerNameCreated], [OwnerNameUpdated], [OwnerNameDeleted], [FileTypeId]) VALUES (@XSLTModelFileID,@XSLTModelFileOED, N'Canonical to Model Loc Tranformation File', 1, 1, 105, getdate(), getdate(), NULL, N'Sys', N'Sys', NULL, 110) --XSLT2
INSERT [dbo].[File] ([FileId], [FileName], [FileDesc], [SourceID], [OwnerID], [LocationID], [DateTimeCreated], [DateTimeUpdated], [DateTimeDeleted], [OwnerNameCreated], [OwnerNameUpdated], [OwnerNameDeleted], [FileTypeId]) VALUES (@ToModelXSDFileID,@ToModelXSDFileOED, N'Canonical Loc Validation File', 1, 1, 106, getdate(), getdate(), NULL, N'Sys', N'Sys', NULL, 109) --XSD3
INSERT [dbo].[File] ([FileId], [FileName], [FileDesc], [SourceID], [OwnerID], [LocationID], [DateTimeCreated], [DateTimeUpdated], [DateTimeDeleted], [OwnerNameCreated], [OwnerNameUpdated], [OwnerNameDeleted], [FileTypeId]) VALUES (@FromAccXSDFileID,@FromAccXSDFileOED, N'Source Acc Validation File', 1, 1, 106, getdate(), getdate(), NULL, N'Sys', N'Sys', NULL, 109) --XSD4
INSERT [dbo].[File] ([FileId], [FileName], [FileDesc], [SourceID], [OwnerID], [LocationID], [DateTimeCreated], [DateTimeUpdated], [DateTimeDeleted], [OwnerNameCreated], [OwnerNameUpdated], [OwnerNameDeleted], [FileTypeId]) VALUES (@XSLTAccFileID,@XSLTAccFileOED, N'Source to Canonical Acc Tranformation File', 1, 1, 105, getdate(), getdate(), NULL, N'Sys', N'Sys', NULL, 110) --XSLT3
INSERT [dbo].[File] ([FileId], [FileName], [FileDesc], [SourceID], [OwnerID], [LocationID], [DateTimeCreated], [DateTimeUpdated], [DateTimeDeleted], [OwnerNameCreated], [OwnerNameUpdated], [OwnerNameDeleted], [FileTypeId]) VALUES (@ToAccAXSDFileID,@ToAccAXSDFileOED, N'Canonical Acc Validation File', 1, 1, 106, getdate(), getdate(), NULL, N'Sys', N'Sys', NULL, 109) --XSD5a
INSERT [dbo].[File] ([FileId], [FileName], [FileDesc], [SourceID], [OwnerID], [LocationID], [DateTimeCreated], [DateTimeUpdated], [DateTimeDeleted], [OwnerNameCreated], [OwnerNameUpdated], [OwnerNameDeleted], [FileTypeId]) VALUES (@ToAccBXSDFileID,@ToAccBXSDFileOED, N'Canonical Acc Profile File', 1, 1, 106, getdate(), getdate(), NULL, N'Sys', N'Sys', NULL, 109) --XSD5b


--FileResource
INSERT [dbo].[FileResource] ([FileResourceId], [FileId], [ResourceId]) VALUES (@FromLocXSDFileResourceID,	@FromLocXSDFileID,	@FromLocXSDResourceID)
INSERT [dbo].[FileResource] ([FileResourceId], [FileId], [ResourceId]) VALUES (@XSLTLocFileResourceID,		@XSLTLocFileID,		@XSLTLocResourceID)
INSERT [dbo].[FileResource] ([FileResourceId], [FileId], [ResourceId]) VALUES (@ToLocAXSDFileResourceID,	@ToLocAXSDFileID,	@ToLocAXSDResourceID)
INSERT [dbo].[FileResource] ([FileResourceId], [FileId], [ResourceId]) VALUES (@ToLocBXSDFileResourceID,	@ToLocBXSDFileID,	@ToLocBXSDResourceID)

INSERT [dbo].[FileResource] ([FileResourceId], [FileId], [ResourceId]) VALUES (@FromModelXSDFileResourceID,	@ToLocBXSDFileID,	@FromModelXSDResourceID)
INSERT [dbo].[FileResource] ([FileResourceId], [FileId], [ResourceId]) VALUES (@XSLTModelFileResourceID,	@XSLTModelFileID,	@XSLTModelResourceID)
INSERT [dbo].[FileResource] ([FileResourceId], [FileId], [ResourceId]) VALUES (@ToModelXSDFileResourceID,	@ToModelXSDFileID,	@ToModelXSDResourceID)

INSERT [dbo].[FileResource] ([FileResourceId], [FileId], [ResourceId]) VALUES (@FromAccXSDFileResourceID,	@FromAccXSDFileID,	@FromAccXSDResourceID)
INSERT [dbo].[FileResource] ([FileResourceId], [FileId], [ResourceId]) VALUES (@XSLTAccFileResourceID,		@XSLTAccFileID,		@XSLTAccResourceID)
INSERT [dbo].[FileResource] ([FileResourceId], [FileId], [ResourceId]) VALUES (@ToAccAXSDFileResourceID,	@ToAccAXSDFileID,	@ToAccAXSDResourceID)
INSERT [dbo].[FileResource] ([FileResourceId], [FileId], [ResourceId]) VALUES (@ToAccBXSDFileResourceID,	@ToAccBXSDFileID,	@ToAccBXSDResourceID)

--Profile
INSERT [dbo].[Profile] ([ProfileID], [ProfileName], [ProfileTypeID]) VALUES (@LocProfileId, @ProfileNameLocOED, 1)
INSERT [dbo].[Profile] ([ProfileID], [ProfileName], [ProfileTypeID]) VALUES (@AccProfileId, @ProfileNameAccOED, 2)

--ProfileResource
INSERT [dbo].[ProfileResource] ([ProfileResourceID], [ProfileID], [ResourceId]) VALUES (@ProfileResourceId, @LocProfileId, @LocProfileResourceID)
INSERT [dbo].[ProfileResource] ([ProfileResourceID], [ProfileID], [ResourceId]) VALUES (@ProfileResourceId+1, @AccProfileId, @AccProfileResourceID)

--ProfileElements
set @int = 0
set @int2 = 0
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'ROW_ID',@LocProfileId,5,3) 
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'PortNumber',@LocProfileId,5,62) 
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'AccNumber',@LocProfileId,16,6) 
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'LocNumber',@LocProfileId,5,10) 
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'CountryCode',@LocProfileId,5,0) 
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'Latitude',@LocProfileId,5,0) 
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'Longitude',@LocProfileId,5,0) 
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'OccupancyCode',@LocProfileId,5,14) 
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'LocUserDef1',@LocProfileId,5,0) 
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'LocPerilsCovered',@LocProfileId,5,0) 
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'BuildingTIV',@LocProfileId,5,2)
	set @int2=@int2+1 INSERT [dbo].[ProfileValueDetail] ([ProfileValueDetailID], [ProfileElementID],[PerilID],[CoverageTypeID],[ElementDimensionID]) VALUES (@int2+@ProfileValueDetailID ,@int+@ProfileElementId,@ModelPerilId+1,@ModelCoverageTypeId+1,1)
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'OtherTIV',@LocProfileId,5,2)
	set @int2=@int2+1 INSERT [dbo].[ProfileValueDetail] ([ProfileValueDetailID], [ProfileElementID],[PerilID],[CoverageTypeID],[ElementDimensionID]) VALUES (@int2+@ProfileValueDetailID ,@int+@ProfileElementId,@ModelPerilId+1,@ModelCoverageTypeId+2,2)
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'ContentsTIV',@LocProfileId,5,2)
	set @int2=@int2+1 INSERT [dbo].[ProfileValueDetail] ([ProfileValueDetailID], [ProfileElementID],[PerilID],[CoverageTypeID],[ElementDimensionID]) VALUES (@int2+@ProfileValueDetailID ,@int+@ProfileElementId,@ModelPerilId+1,@ModelCoverageTypeId+3,3)
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'BITIV',@LocProfileId,5,2)
	set @int2=@int2+1 INSERT [dbo].[ProfileValueDetail] ([ProfileValueDetailID], [ProfileElementID],[PerilID],[CoverageTypeID],[ElementDimensionID]) VALUES (@int2+@ProfileValueDetailID ,@int+@ProfileElementId,@ModelPerilId+1,@ModelCoverageTypeId+4,4)
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'BIPOI',@LocProfileId,5,0) 
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'LocCurrency',@LocProfileId,5,0) 
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'LocDed1Building',@LocProfileId,14,16)
	set @int2=@int2+1 INSERT [dbo].[ProfileValueDetail] ([ProfileValueDetailID], [ProfileElementID],[PerilID],[CoverageTypeID],[ElementDimensionID]) VALUES (@int2+@ProfileValueDetailID ,@int+@ProfileElementId,@ModelPerilId+1,@ModelCoverageTypeId+1,1)
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'LocDed2Other',@LocProfileId,14,16)
	set @int2=@int2+1 INSERT [dbo].[ProfileValueDetail] ([ProfileValueDetailID], [ProfileElementID],[PerilID],[CoverageTypeID],[ElementDimensionID]) VALUES (@int2+@ProfileValueDetailID ,@int+@ProfileElementId,@ModelPerilId+1,@ModelCoverageTypeId+2,2)
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'LocDed3Contents',@LocProfileId,14,16)
	set @int2=@int2+1 INSERT [dbo].[ProfileValueDetail] ([ProfileValueDetailID], [ProfileElementID],[PerilID],[CoverageTypeID],[ElementDimensionID]) VALUES (@int2+@ProfileValueDetailID ,@int+@ProfileElementId,@ModelPerilId+1,@ModelCoverageTypeId+3,3)
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'LocDed4BI',@LocProfileId,14,16) 
	set @int2=@int2+1 INSERT [dbo].[ProfileValueDetail] ([ProfileValueDetailID], [ProfileElementID],[PerilID],[CoverageTypeID],[ElementDimensionID]) VALUES (@int2+@ProfileValueDetailID ,@int+@ProfileElementId,@ModelPerilId+1,@ModelCoverageTypeId+4,4)
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'LocDed5PD',@LocProfileId,14,20) 
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'LocDed6All',@LocProfileId,14,18) 
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'LocLimit1Building',@LocProfileId,14,15) 
	set @int2=@int2+1 INSERT [dbo].[ProfileValueDetail] ([ProfileValueDetailID], [ProfileElementID],[PerilID],[CoverageTypeID],[ElementDimensionID]) VALUES (@int2+@ProfileValueDetailID ,@int+@ProfileElementId,@ModelPerilId+1,@ModelCoverageTypeId+1,1)
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'LocLimit2Other',@LocProfileId,14,15)
	set @int2=@int2+1 INSERT [dbo].[ProfileValueDetail] ([ProfileValueDetailID], [ProfileElementID],[PerilID],[CoverageTypeID],[ElementDimensionID]) VALUES (@int2+@ProfileValueDetailID ,@int+@ProfileElementId,@ModelPerilId+1,@ModelCoverageTypeId+2,2)
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'LocLimit3Contents',@LocProfileId,14,15)
	set @int2=@int2+1 INSERT [dbo].[ProfileValueDetail] ([ProfileValueDetailID], [ProfileElementID],[PerilID],[CoverageTypeID],[ElementDimensionID]) VALUES (@int2+@ProfileValueDetailID ,@int+@ProfileElementId,@ModelPerilId+1,@ModelCoverageTypeId+3,3)
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'LocLimit4BI',@LocProfileId,14,15)
	set @int2=@int2+1 INSERT [dbo].[ProfileValueDetail] ([ProfileValueDetailID], [ProfileElementID],[PerilID],[CoverageTypeID],[ElementDimensionID]) VALUES (@int2+@ProfileValueDetailID ,@int+@ProfileElementId,@ModelPerilId+1,@ModelCoverageTypeId+4,4)
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'LocLimit5PD',@LocProfileId,14,19) 
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'LocLimit6All',@LocProfileId,14,17) 

set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'CondNumber',@LocProfileId,14,54)
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'CondPriority',@LocProfileId,14,0)
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'CondMinDed6All',@LocProfileId,14,56)
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'CondLimit6All',@LocProfileId,14,55)

set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'ROW_ID',@AccProfileId,16,1) 
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'PortNumber',@AccProfileId,16,0) 
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'AccNumber',@AccProfileId,16,6) 
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'AccCurrency',@AccProfileId,16,0) 
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'PolNumber',@AccProfileId,16,21) 
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'PolPerilsCovered',@AccProfileId,16,0) 
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'LayerNumber',@AccProfileId,16,0) 
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'LayerParticipation',@AccProfileId,20,57) 
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'LayerLimit',@AccProfileId,20,24) 
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'LayerAttachment',@AccProfileId,20,23) 
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'PolDed6All',@AccProfileId,20,27) 
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'PolMinDed6All',@AccProfileId,20,25) 
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'PolMaxDed6All',@AccProfileId,20,26) 
set @int=@int+1  insert into [ProfileElement] values (@int+@ProfileElementId,'CondNumber',@AccProfileId,16,0) 


GO
