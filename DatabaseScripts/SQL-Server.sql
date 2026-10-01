IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [Categories] (
    [Id] uniqueidentifier NOT NULL,
    [Name] nvarchar(max) NULL,
    [Description] nvarchar(max) NULL,
    [ParentId] uniqueidentifier NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [ModifiedDate] datetime2 NOT NULL DEFAULT (getdate()),
    [ModifiedBy] uniqueidentifier NOT NULL,
    [DeletedDate] datetime2 NULL,
    [DeletedBy] uniqueidentifier NOT NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_Categories] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Categories_Categories_ParentId] FOREIGN KEY ([ParentId]) REFERENCES [Categories] ([Id]) ON DELETE NO ACTION
);
GO

CREATE TABLE [DocumentTokens] (
    [Id] uniqueidentifier NOT NULL,
    [DocumentId] uniqueidentifier NOT NULL,
    [Token] uniqueidentifier NOT NULL,
    [CreatedDate] datetime2 NOT NULL,
    CONSTRAINT [PK_DocumentTokens] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [EmailSMTPSettings] (
    [Id] uniqueidentifier NOT NULL,
    [Host] nvarchar(max) NOT NULL,
    [UserName] nvarchar(max) NOT NULL,
    [Password] nvarchar(max) NOT NULL,
    [IsEnableSSL] bit NOT NULL,
    [Port] int NOT NULL,
    [IsDefault] bit NOT NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [ModifiedDate] datetime2 NOT NULL,
    [ModifiedBy] uniqueidentifier NOT NULL,
    [DeletedDate] datetime2 NULL,
    [DeletedBy] uniqueidentifier NOT NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_EmailSMTPSettings] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [LoginAudits] (
    [Id] uniqueidentifier NOT NULL,
    [UserName] nvarchar(max) NULL,
    [LoginTime] datetime2 NOT NULL,
    [RemoteIP] nvarchar(50) NULL,
    [Status] nvarchar(max) NULL,
    [Provider] nvarchar(max) NULL,
    [Latitude] nvarchar(50) NULL,
    [Longitude] nvarchar(50) NULL,
    CONSTRAINT [PK_LoginAudits] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [NLog] (
    [Id] uniqueidentifier NOT NULL,
    [MachineName] nvarchar(max) NULL,
    [Logged] nvarchar(max) NULL,
    [Level] nvarchar(max) NULL,
    [Message] nvarchar(max) NULL,
    [Logger] nvarchar(max) NULL,
    [Properties] nvarchar(max) NULL,
    [Callsite] nvarchar(max) NULL,
    [Exception] nvarchar(max) NULL,
    CONSTRAINT [PK_NLog] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [Operations] (
    [Id] uniqueidentifier NOT NULL,
    [Name] nvarchar(max) NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [ModifiedDate] datetime2 NOT NULL DEFAULT (getdate()),
    [ModifiedBy] uniqueidentifier NOT NULL,
    [DeletedDate] datetime2 NULL,
    [DeletedBy] uniqueidentifier NOT NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_Operations] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [Roles] (
    [Id] uniqueidentifier NOT NULL,
    [IsDeleted] bit NOT NULL,
    [Name] nvarchar(256) NULL,
    [NormalizedName] nvarchar(256) NULL,
    [ConcurrencyStamp] nvarchar(max) NULL,
    CONSTRAINT [PK_Roles] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [Screens] (
    [Id] uniqueidentifier NOT NULL,
    [Name] nvarchar(max) NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [ModifiedDate] datetime2 NOT NULL DEFAULT (getdate()),
    [ModifiedBy] uniqueidentifier NOT NULL,
    [DeletedDate] datetime2 NULL,
    [DeletedBy] uniqueidentifier NOT NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_Screens] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [Users] (
    [Id] uniqueidentifier NOT NULL,
    [FirstName] nvarchar(max) NULL,
    [LastName] nvarchar(max) NULL,
    [IsDeleted] bit NOT NULL,
    [UserName] nvarchar(256) NULL,
    [NormalizedUserName] nvarchar(256) NULL,
    [Email] nvarchar(256) NULL,
    [NormalizedEmail] nvarchar(256) NULL,
    [EmailConfirmed] bit NOT NULL,
    [PasswordHash] nvarchar(max) NULL,
    [SecurityStamp] nvarchar(max) NULL,
    [ConcurrencyStamp] nvarchar(max) NULL,
    [PhoneNumber] nvarchar(max) NULL,
    [PhoneNumberConfirmed] bit NOT NULL,
    [TwoFactorEnabled] bit NOT NULL,
    [LockoutEnd] datetimeoffset NULL,
    [LockoutEnabled] bit NOT NULL,
    [AccessFailedCount] int NOT NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [RoleClaims] (
    [Id] int NOT NULL IDENTITY,
    [OperationId] uniqueidentifier NOT NULL,
    [ScreenId] uniqueidentifier NOT NULL,
    [RoleId] uniqueidentifier NOT NULL,
    [ClaimType] nvarchar(max) NULL,
    [ClaimValue] nvarchar(max) NULL,
    CONSTRAINT [PK_RoleClaims] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_RoleClaims_Operations_OperationId] FOREIGN KEY ([OperationId]) REFERENCES [Operations] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_RoleClaims_Roles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [Roles] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_RoleClaims_Screens_ScreenId] FOREIGN KEY ([ScreenId]) REFERENCES [Screens] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [ScreenOperations] (
    [Id] uniqueidentifier NOT NULL,
    [OperationId] uniqueidentifier NOT NULL,
    [ScreenId] uniqueidentifier NOT NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [ModifiedDate] datetime2 NOT NULL DEFAULT (getdate()),
    [ModifiedBy] uniqueidentifier NOT NULL,
    [DeletedDate] datetime2 NULL,
    [DeletedBy] uniqueidentifier NOT NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_ScreenOperations] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_ScreenOperations_Operations_OperationId] FOREIGN KEY ([OperationId]) REFERENCES [Operations] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_ScreenOperations_Screens_ScreenId] FOREIGN KEY ([ScreenId]) REFERENCES [Screens] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [Documents] (
    [Id] uniqueidentifier NOT NULL,
    [CategoryId] uniqueidentifier NOT NULL,
    [Name] nvarchar(max) NULL,
    [Description] nvarchar(max) NULL,
    [Url] nvarchar(450) NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [ModifiedDate] datetime2 NOT NULL DEFAULT (getdate()),
    [ModifiedBy] uniqueidentifier NOT NULL,
    [DeletedDate] datetime2 NULL,
    [DeletedBy] uniqueidentifier NOT NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_Documents] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Documents_Categories_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [Categories] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_Documents_Users_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [Users] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [UserClaims] (
    [Id] int NOT NULL IDENTITY,
    [OperationId] uniqueidentifier NOT NULL,
    [ScreenId] uniqueidentifier NOT NULL,
    [UserId] uniqueidentifier NOT NULL,
    [ClaimType] nvarchar(max) NULL,
    [ClaimValue] nvarchar(max) NULL,
    CONSTRAINT [PK_UserClaims] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_UserClaims_Operations_OperationId] FOREIGN KEY ([OperationId]) REFERENCES [Operations] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_UserClaims_Screens_ScreenId] FOREIGN KEY ([ScreenId]) REFERENCES [Screens] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_UserClaims_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [UserLogins] (
    [LoginProvider] nvarchar(450) NOT NULL,
    [ProviderKey] nvarchar(450) NOT NULL,
    [ProviderDisplayName] nvarchar(max) NULL,
    [UserId] uniqueidentifier NOT NULL,
    CONSTRAINT [PK_UserLogins] PRIMARY KEY ([LoginProvider], [ProviderKey]),
    CONSTRAINT [FK_UserLogins_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [UserRoles] (
    [UserId] uniqueidentifier NOT NULL,
    [RoleId] uniqueidentifier NOT NULL,
    CONSTRAINT [PK_UserRoles] PRIMARY KEY ([UserId], [RoleId]),
    CONSTRAINT [FK_UserRoles_Roles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [Roles] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_UserRoles_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [UserTokens] (
    [UserId] uniqueidentifier NOT NULL,
    [LoginProvider] nvarchar(450) NOT NULL,
    [Name] nvarchar(450) NOT NULL,
    [Value] nvarchar(max) NULL,
    CONSTRAINT [PK_UserTokens] PRIMARY KEY ([UserId], [LoginProvider], [Name]),
    CONSTRAINT [FK_UserTokens_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [DocumentAuditTrails] (
    [Id] uniqueidentifier NOT NULL,
    [DocumentId] uniqueidentifier NOT NULL,
    [OperationName] int NOT NULL,
    [AssignToUserId] uniqueidentifier NULL,
    [AssignToRoleId] uniqueidentifier NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [ModifiedDate] datetime2 NOT NULL DEFAULT (getdate()),
    [ModifiedBy] uniqueidentifier NOT NULL,
    [DeletedDate] datetime2 NULL,
    [DeletedBy] uniqueidentifier NOT NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_DocumentAuditTrails] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_DocumentAuditTrails_Documents_DocumentId] FOREIGN KEY ([DocumentId]) REFERENCES [Documents] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_DocumentAuditTrails_Roles_AssignToRoleId] FOREIGN KEY ([AssignToRoleId]) REFERENCES [Roles] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_DocumentAuditTrails_Users_AssignToUserId] FOREIGN KEY ([AssignToUserId]) REFERENCES [Users] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_DocumentAuditTrails_Users_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [Users] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [DocumentRolePermissions] (
    [Id] uniqueidentifier NOT NULL,
    [DocumentId] uniqueidentifier NOT NULL,
    [RoleId] uniqueidentifier NOT NULL,
    [StartDate] datetime2 NULL,
    [EndDate] datetime2 NULL,
    [IsTimeBound] bit NOT NULL,
    [IsAllowDownload] bit NOT NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [ModifiedDate] datetime2 NOT NULL,
    [ModifiedBy] uniqueidentifier NOT NULL,
    [DeletedDate] datetime2 NULL,
    [DeletedBy] uniqueidentifier NOT NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_DocumentRolePermissions] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_DocumentRolePermissions_Documents_DocumentId] FOREIGN KEY ([DocumentId]) REFERENCES [Documents] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_DocumentRolePermissions_Roles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [Roles] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_DocumentRolePermissions_Users_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [Users] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [DocumentUserPermissions] (
    [Id] uniqueidentifier NOT NULL,
    [DocumentId] uniqueidentifier NOT NULL,
    [UserId] uniqueidentifier NOT NULL,
    [StartDate] datetime2 NULL,
    [EndDate] datetime2 NULL,
    [IsTimeBound] bit NOT NULL,
    [IsAllowDownload] bit NOT NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [ModifiedDate] datetime2 NOT NULL,
    [ModifiedBy] uniqueidentifier NOT NULL,
    [DeletedDate] datetime2 NULL,
    [DeletedBy] uniqueidentifier NOT NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_DocumentUserPermissions] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_DocumentUserPermissions_Documents_DocumentId] FOREIGN KEY ([DocumentId]) REFERENCES [Documents] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_DocumentUserPermissions_Users_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [Users] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_DocumentUserPermissions_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE NO ACTION
);
GO

CREATE TABLE [Reminders] (
    [Id] uniqueidentifier NOT NULL,
    [Subject] nvarchar(max) NULL,
    [Message] nvarchar(max) NULL,
    [Frequency] int NULL,
    [StartDate] datetime2 NOT NULL,
    [EndDate] datetime2 NULL,
    [DayOfWeek] int NULL,
    [IsRepeated] bit NOT NULL,
    [IsEmailNotification] bit NOT NULL,
    [DocumentId] uniqueidentifier NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [ModifiedDate] datetime2 NOT NULL,
    [ModifiedBy] uniqueidentifier NOT NULL,
    [DeletedDate] datetime2 NULL,
    [DeletedBy] uniqueidentifier NOT NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_Reminders] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Reminders_Documents_DocumentId] FOREIGN KEY ([DocumentId]) REFERENCES [Documents] ([Id]) ON DELETE NO ACTION
);
GO

CREATE TABLE [ReminderSchedulers] (
    [Id] uniqueidentifier NOT NULL,
    [Duration] datetime2 NOT NULL,
    [IsActive] bit NOT NULL,
    [Frequency] int NULL,
    [CreatedDate] datetime2 NOT NULL,
    [DocumentId] uniqueidentifier NULL,
    [UserId] uniqueidentifier NOT NULL,
    [IsRead] bit NOT NULL,
    [IsEmailNotification] bit NOT NULL,
    [Subject] nvarchar(max) NULL,
    [Message] nvarchar(max) NULL,
    CONSTRAINT [PK_ReminderSchedulers] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_ReminderSchedulers_Documents_DocumentId] FOREIGN KEY ([DocumentId]) REFERENCES [Documents] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_ReminderSchedulers_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [SendEmails] (
    [Id] uniqueidentifier NOT NULL,
    [Subject] nvarchar(max) NULL,
    [Message] nvarchar(max) NULL,
    [FromEmail] nvarchar(max) NULL,
    [DocumentId] uniqueidentifier NULL,
    [IsSend] bit NOT NULL,
    [Email] nvarchar(max) NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [ModifiedDate] datetime2 NOT NULL,
    [ModifiedBy] uniqueidentifier NOT NULL,
    [DeletedDate] datetime2 NULL,
    [DeletedBy] uniqueidentifier NOT NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_SendEmails] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_SendEmails_Documents_DocumentId] FOREIGN KEY ([DocumentId]) REFERENCES [Documents] ([Id]) ON DELETE NO ACTION
);
GO

CREATE TABLE [UserNotifications] (
    [Id] uniqueidentifier NOT NULL,
    [UserId] uniqueidentifier NOT NULL,
    [Message] nvarchar(max) NULL,
    [IsRead] bit NOT NULL,
    [DocumentId] uniqueidentifier NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [ModifiedDate] datetime2 NOT NULL,
    [ModifiedBy] uniqueidentifier NOT NULL,
    [DeletedDate] datetime2 NULL,
    [DeletedBy] uniqueidentifier NOT NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_UserNotifications] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_UserNotifications_Documents_DocumentId] FOREIGN KEY ([DocumentId]) REFERENCES [Documents] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_UserNotifications_Users_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [Users] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_UserNotifications_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id])
);
GO

CREATE TABLE [DailyReminders] (
    [Id] uniqueidentifier NOT NULL,
    [ReminderId] uniqueidentifier NOT NULL,
    [DayOfWeek] int NOT NULL,
    [IsActive] bit NOT NULL,
    CONSTRAINT [PK_DailyReminders] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_DailyReminders_Reminders_ReminderId] FOREIGN KEY ([ReminderId]) REFERENCES [Reminders] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [HalfYearlyReminders] (
    [Id] uniqueidentifier NOT NULL,
    [ReminderId] uniqueidentifier NOT NULL,
    [Day] int NOT NULL,
    [Month] int NOT NULL,
    [Quarter] int NOT NULL,
    CONSTRAINT [PK_HalfYearlyReminders] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_HalfYearlyReminders_Reminders_ReminderId] FOREIGN KEY ([ReminderId]) REFERENCES [Reminders] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [QuarterlyReminders] (
    [Id] uniqueidentifier NOT NULL,
    [ReminderId] uniqueidentifier NOT NULL,
    [Day] int NOT NULL,
    [Month] int NOT NULL,
    [Quarter] int NOT NULL,
    CONSTRAINT [PK_QuarterlyReminders] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_QuarterlyReminders_Reminders_ReminderId] FOREIGN KEY ([ReminderId]) REFERENCES [Reminders] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [ReminderNotifications] (
    [Id] uniqueidentifier NOT NULL,
    [ReminderId] uniqueidentifier NOT NULL,
    [Subject] nvarchar(max) NULL,
    [Description] nvarchar(max) NULL,
    [FetchDateTime] datetime2 NOT NULL,
    [IsDeleted] bit NOT NULL,
    [IsEmailNotification] bit NOT NULL,
    CONSTRAINT [PK_ReminderNotifications] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_ReminderNotifications_Reminders_ReminderId] FOREIGN KEY ([ReminderId]) REFERENCES [Reminders] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [ReminderUsers] (
    [ReminderId] uniqueidentifier NOT NULL,
    [UserId] uniqueidentifier NOT NULL,
    CONSTRAINT [PK_ReminderUsers] PRIMARY KEY ([ReminderId], [UserId]),
    CONSTRAINT [FK_ReminderUsers_Reminders_ReminderId] FOREIGN KEY ([ReminderId]) REFERENCES [Reminders] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_ReminderUsers_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id])
);
GO

CREATE INDEX [IX_Categories_ParentId] ON [Categories] ([ParentId]);
GO

CREATE INDEX [IX_DailyReminders_ReminderId] ON [DailyReminders] ([ReminderId]);
GO

CREATE INDEX [IX_DocumentAuditTrails_AssignToRoleId] ON [DocumentAuditTrails] ([AssignToRoleId]);
GO

CREATE INDEX [IX_DocumentAuditTrails_AssignToUserId] ON [DocumentAuditTrails] ([AssignToUserId]);
GO

CREATE INDEX [IX_DocumentAuditTrails_CreatedBy] ON [DocumentAuditTrails] ([CreatedBy]);
GO

CREATE INDEX [IX_DocumentAuditTrails_DocumentId] ON [DocumentAuditTrails] ([DocumentId]);
GO

CREATE INDEX [IX_DocumentRolePermissions_CreatedBy] ON [DocumentRolePermissions] ([CreatedBy]);
GO

CREATE INDEX [IX_DocumentRolePermissions_DocumentId] ON [DocumentRolePermissions] ([DocumentId]);
GO

CREATE INDEX [IX_DocumentRolePermissions_RoleId] ON [DocumentRolePermissions] ([RoleId]);
GO

CREATE INDEX [IX_Documents_CategoryId] ON [Documents] ([CategoryId]);
GO

CREATE INDEX [IX_Documents_CreatedBy] ON [Documents] ([CreatedBy]);
GO

CREATE INDEX [IX_Documents_Url] ON [Documents] ([Url]);
GO

CREATE INDEX [IX_DocumentUserPermissions_CreatedBy] ON [DocumentUserPermissions] ([CreatedBy]);
GO

CREATE INDEX [IX_DocumentUserPermissions_DocumentId] ON [DocumentUserPermissions] ([DocumentId]);
GO

CREATE INDEX [IX_DocumentUserPermissions_UserId] ON [DocumentUserPermissions] ([UserId]);
GO

CREATE INDEX [IX_HalfYearlyReminders_ReminderId] ON [HalfYearlyReminders] ([ReminderId]);
GO

CREATE INDEX [IX_QuarterlyReminders_ReminderId] ON [QuarterlyReminders] ([ReminderId]);
GO

CREATE INDEX [IX_ReminderNotifications_ReminderId] ON [ReminderNotifications] ([ReminderId]);
GO

CREATE INDEX [IX_Reminders_DocumentId] ON [Reminders] ([DocumentId]);
GO

CREATE INDEX [IX_ReminderSchedulers_DocumentId] ON [ReminderSchedulers] ([DocumentId]);
GO

CREATE INDEX [IX_ReminderSchedulers_UserId] ON [ReminderSchedulers] ([UserId]);
GO

CREATE INDEX [IX_ReminderUsers_UserId] ON [ReminderUsers] ([UserId]);
GO

CREATE INDEX [IX_RoleClaims_OperationId] ON [RoleClaims] ([OperationId]);
GO

CREATE INDEX [IX_RoleClaims_RoleId] ON [RoleClaims] ([RoleId]);
GO

CREATE INDEX [IX_RoleClaims_ScreenId] ON [RoleClaims] ([ScreenId]);
GO

CREATE UNIQUE INDEX [RoleNameIndex] ON [Roles] ([NormalizedName]) WHERE [NormalizedName] IS NOT NULL;
GO

CREATE INDEX [IX_ScreenOperations_OperationId] ON [ScreenOperations] ([OperationId]);
GO

CREATE INDEX [IX_ScreenOperations_ScreenId] ON [ScreenOperations] ([ScreenId]);
GO

CREATE INDEX [IX_SendEmails_DocumentId] ON [SendEmails] ([DocumentId]);
GO

CREATE INDEX [IX_UserClaims_OperationId] ON [UserClaims] ([OperationId]);
GO

CREATE INDEX [IX_UserClaims_ScreenId] ON [UserClaims] ([ScreenId]);
GO

CREATE INDEX [IX_UserClaims_UserId] ON [UserClaims] ([UserId]);
GO

CREATE INDEX [IX_UserLogins_UserId] ON [UserLogins] ([UserId]);
GO

CREATE INDEX [IX_UserNotifications_CreatedBy] ON [UserNotifications] ([CreatedBy]);
GO

CREATE INDEX [IX_UserNotifications_DocumentId] ON [UserNotifications] ([DocumentId]);
GO

CREATE INDEX [IX_UserNotifications_UserId] ON [UserNotifications] ([UserId]);
GO

CREATE INDEX [IX_UserRoles_RoleId] ON [UserRoles] ([RoleId]);
GO

CREATE INDEX [EmailIndex] ON [Users] ([NormalizedEmail]);
GO

CREATE UNIQUE INDEX [UserNameIndex] ON [Users] ([NormalizedUserName]) WHERE [NormalizedUserName] IS NOT NULL;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20211222114952_Initial', N'8.0.13');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

-- Users
INSERT [dbo].[Users] ([Id], [FirstName], [LastName], [IsDeleted], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount]) VALUES (N'1a5cf5b9-ead8-495c-8719-2d8be776f452', N'Shirley', N'Heitzman', 0, N'employee@gmail.com', N'EMPLOYEE@GMAIL.COM', N'employee@gmail.com', N'EMPLOYEE@GMAIL.COM', 0, N'AQAAAAEAACcQAAAAEISmz8S4E4dOhEPhhcQ6xmdJCNeez7fmWB6tXa1h2yKrwD3lO+lX+eKSeKdgPB/Mcw==', N'HFC3ZVYIMS63F5H6FHWNDUFRLRI4RDEG', N'6b2c2644-949a-4d2c-99fe-bb72411b6eb2', N'9904750722', 0, 0, NULL, 1, 0)
INSERT [dbo].[Users] ([Id], [FirstName], [LastName], [IsDeleted], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount]) VALUES (N'4b352b37-332a-40c6-ab05-e38fcf109719', N'David', N'Parnell', 0, N'admin@gmail.com', N'ADMIN@GMAIL.COM', N'admin@gmail.com', N'ADMIN@GMAIL.COM', 0, N'AQAAAAEAACcQAAAAEM60FYHL5RMKNeB+CxCOI41EC8Vsr1B3Dyrrr2BOtZrxz6doL8o6Tv/tYGDRk20t1A==', N'5D4GQ7LLLVRQJDQFNUGUU763GELSABOJ', N'dde0074a-2914-476c-bd3b-63622da1dbeb', N'1234567890', 0, 0, NULL, 1, 0)

-- Categories
INSERT [dbo].[Categories] ([Id], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted], [ParentId]) VALUES (N'9cc497f5-1736-4bc6-84a8-316fd983b732', N'HR Policies', NULL, CAST(N'2021-12-22T17:13:13.4469583' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T17:13:13.4466667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0, NULL)
INSERT [dbo].[Categories] ([Id], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted], [ParentId]) VALUES (N'4dbbd372-6acf-4e5d-a1cf-3ca3f7cc190d', N'HR Policies 2020', N'', CAST(N'2021-12-22T17:13:38.7871646' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T17:13:38.7900000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0, N'9cc497f5-1736-4bc6-84a8-316fd983b732')
INSERT [dbo].[Categories] ([Id], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted], [ParentId]) VALUES (N'0e628f62-c710-40f2-949d-5b38583869f2', N'HR Policies 2021', N'', CAST(N'2021-12-22T17:13:48.4922407' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T17:13:48.4933333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0, N'9cc497f5-1736-4bc6-84a8-316fd983b732')
INSERT [dbo].[Categories] ([Id], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted], [ParentId]) VALUES (N'a465e640-4a44-44e9-9821-630cc8da4a4c', N'Confidential', NULL, CAST(N'2021-12-22T17:13:06.8971286' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T17:13:06.8966667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0, NULL)
INSERT [dbo].[Categories] ([Id], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted], [ParentId]) VALUES (N'48c4c825-04d7-44c5-84c8-6d134cb9b36b', N'Logbooks', NULL, CAST(N'2021-12-22T17:12:44.7875398' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T17:12:44.7900000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0, NULL)
INSERT [dbo].[Categories] ([Id], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted], [ParentId]) VALUES (N'e6bc300e-6600-442e-b452-9a13213ab980', N'Quality Assurance Document', NULL, CAST(N'2021-12-22T17:13:25.7641267' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T17:13:25.7633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0, NULL)
INSERT [dbo].[Categories] ([Id], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted], [ParentId]) VALUES (N'ad57c02a-b6cf-4aa3-aad7-9c014c41b3e6', N'SOP Production', NULL, CAST(N'2021-12-22T17:12:56.6720077' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T17:12:56.6700000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0, NULL)
INSERT [dbo].[Categories] ([Id], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted], [ParentId]) VALUES (N'04226dd5-fedc-4fbd-8ba9-c0a5b72c5b39', N'Resume', NULL, CAST(N'2021-12-22T17:12:49.0555527' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T17:12:49.0566667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0, NULL)

-- Operations
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'c288b5d3-419d-4dc0-9e5a-083194016d2c', N'Edit Role', CAST(N'2021-12-22T16:19:27.0969638' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:19:27.0966667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'41f65d07-9023-4cfb-9c7c-0e3247a012e0', N'View SMTP Settings', CAST(N'2021-12-22T17:10:54.4083253' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T17:10:54.4100000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'229ad778-c7d3-4f5f-ab52-24b537c39514', N'Delete Document', CAST(N'2021-12-22T16:18:30.3499854' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:18:30.3533333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'752ae5b8-e34f-4b32-81f2-2cf709881663', N'Edit SMTP Setting', CAST(N'2021-12-22T16:20:21.5000620' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:20:21.5000000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'6f2717fc-edef-4537-916d-2d527251a5c1', N'View Reminders', CAST(N'2021-12-22T17:10:31.0954098' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T17:10:31.0966667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'cd46a3a4-ede5-4941-a49b-3df7eaa46428', N'Edit Category', CAST(N'2021-12-22T16:19:11.9766992' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:19:11.9766667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'63ed1277-1db5-4cf7-8404-3e3426cb4bc5', N'View Documents', CAST(N'2021-12-22T17:08:28.5475520' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T17:08:28.5566667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'6bc0458e-22f5-4975-b387-4d6a4fb35201', N'Create Reminder', CAST(N'2021-12-22T16:20:01.0047984' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:20:01.0066667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'1c7d3e31-08ad-43cf-9cf7-4ffafdda9029', N'View Document Audit Trail', CAST(N'2021-12-22T16:19:19.6713411' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:19:19.6700000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'3ccaf408-8864-4815-a3e0-50632d90bcb6', N'Edit Reminder', CAST(N'2021-12-22T16:20:05.0099657' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:20:05.0166667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'67ae2b97-b24e-41d5-bf39-56b2834548d0', N'Create Category', CAST(N'2021-12-22T16:19:08.4886748' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:19:08.4900000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'595a769d-f7ef-45f3-9f9e-60c58c5e1542', N'Send Email', CAST(N'2021-12-22T16:18:38.5891523' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:18:38.5900000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'e506ec48-b99a-45b4-9ec9-6451bc67477b', N'Assign Permission', CAST(N'2021-12-22T16:19:48.2359350' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:19:48.2366667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'ab45ef6a-a8e6-47ef-a182-6b88e2a6f9aa', N'View Categories', CAST(N'2021-12-22T17:09:09.2608417' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T17:09:09.2600000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'd4d724fc-fd38-49c4-85bc-73937b219e20', N'Reset Password', CAST(N'2021-12-22T16:19:51.9868277' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:19:51.9866667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'7ba630ca-a9d3-42ee-99c8-766e2231fec1', N'View Dashboard', CAST(N'2021-12-22T16:18:17.4262057' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:18:17.4300000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'3da78b4d-d263-4b13-8e81-7aa164a3688c', N'Add Reminder', CAST(N'2021-12-22T16:18:42.2181455' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:18:42.2200000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'ab0544d7-2276-4f3b-b450-7f0fa11c3dd9', N'Create SMTP Setting', CAST(N'2021-12-22T16:20:17.6534586' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:20:17.6533333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'57216dcd-1a1c-4f94-a33d-83a5af2d7a46', N'View Roles', CAST(N'2021-12-22T17:09:43.8015442' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T17:09:43.8033333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'4f19045b-e9a8-403b-b730-8453ee72830e', N'Delete SMTP Setting', CAST(N'2021-12-22T16:20:25.5731214' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:20:25.5733333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'fbe77c07-3058-4dbe-9d56-8c75dc879460', N'Assign User Role', CAST(N'2021-12-22T16:19:56.3240583' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:19:56.3233333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'ff4b3b73-c29f-462a-afa4-94a40e6b2c4a', N'View Login Audit Logs', CAST(N'2021-12-22T16:20:13.3631949' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:20:13.3633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'239035d5-cd44-475f-bbc5-9ef51768d389', N'Create Document', CAST(N'2021-12-22T16:18:22.7285627' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:18:22.7300000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'db8825b1-ee4e-49f6-9a08-b0210ed53fd4', N'Create Role', CAST(N'2021-12-22T16:19:23.9337990' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:19:23.9333333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'31cb6438-7d4a-4385-8a34-b4e8f6096a48', N'View Users', CAST(N'2021-12-22T17:10:05.7725732' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T17:10:05.7733333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'18a5a8f6-7cb6-4178-857d-b6a981ea3d4f', N'Delete Role', CAST(N'2021-12-22T16:19:30.9951456' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:19:30.9966667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'6719a065-8a4a-4350-8582-bfc41ce283fb', N'Download Document', CAST(N'2021-12-22T16:18:46.2300299' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:18:46.2300000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'a8dd972d-e758-4571-8d39-c6fec74b361b', N'Edit Document', CAST(N'2021-12-22T16:18:26.4671126' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:18:26.4666667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'86ce1382-a2b1-48ed-ae81-c9908d00cf3b', N'Create User', CAST(N'2021-12-22T16:19:35.4981545' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:19:35.4966667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'5ea48d56-2ed3-4239-bb90-dd4d70a1b0b2', N'Delete Reminder', CAST(N'2021-12-22T16:20:09.0773918' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:20:09.0800000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'0a2e19fc-d9f2-446c-8ca3-e6b8b73b5f9b', N'Edit User', CAST(N'2021-12-22T16:19:41.0135872' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:19:41.0166667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'2ea6ba08-eb36-4e34-92d9-f1984c908b31', N'Share Document', CAST(N'2021-12-22T16:18:34.8231442' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:18:34.8233333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'9c0e2186-06a4-4207-acbc-f6d8efa430b3', N'Delete Category', CAST(N'2021-12-22T16:19:15.0882259' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:19:15.0900000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'374d74aa-a580-4928-848d-f7553db39914', N'Delete User', CAST(N'2021-12-22T16:19:44.4173351' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:19:44.4166667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'd8f12d11-aa74-49b1-9bce-f945517bffde', N'Archive Folder', CAST(N'2021-12-22T16:19:44.4173351' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:19:44.4166667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)

-- Roles
INSERT [dbo].[Roles] ([Id], [IsDeleted], [Name], [NormalizedName], [ConcurrencyStamp]) VALUES (N'c5d235ea-81b4-4c36-9205-2077da227c0a', 0, N'Employee', N'Employee', N'47432aba-cc42-4113-a49d-cb8548e185b2')
INSERT [dbo].[Roles] ([Id], [IsDeleted], [Name], [NormalizedName], [ConcurrencyStamp]) VALUES (N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', 0, N'Super Admin', N'Super Admin', N'870b5668-b97a-4406-bead-09022612568c')

-- Screens
INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'2e3c07a4-fcac-4303-ae47-0d0f796403c9', N'Email', CAST(N'2021-12-22T16:18:01.0788250' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:18:01.0800000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', N'All Documents', CAST(N'2021-12-22T16:17:23.9712198' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:17:23.9700000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'42e44f15-8e33-423a-ad7f-17edc23d6dd3', N'Dashboard', CAST(N'2021-12-22T16:17:16.4668983' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:17:16.4733333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'97ff6eb0-39b3-4ddd-acf1-43205d5a9bb3', N'Reminder', CAST(N'2021-12-22T16:17:52.9795843' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:17:52.9800000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'f042bbee-d15f-40fb-b79a-8368f2c2e287', N'Login Audit', CAST(N'2021-12-22T16:17:57.4457910' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:17:57.4466667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'2396f81c-f8b5-49ac-88d1-94ed57333f49', N'Document Audit Trail', CAST(N'2021-12-22T16:17:38.6403958' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:17:38.6400000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'324bdc51-d71f-4f80-9f28-a30e8aae4009', N'User', CAST(N'2021-12-22T16:17:48.8833752' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:17:48.8833333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', N'Assigned Documents', CAST(N'2021-12-24T10:15:02.1617631' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-24T10:15:02.1733333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'090ea443-01c7-4638-a194-ad3416a5ea7a', N'Role', CAST(N'2021-12-22T16:17:44.1841942' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:17:44.1833333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'5a5f7cf8-21a6-434a-9330-db91b17d867c', N'Document Category', CAST(N'2021-12-22T16:17:33.3778925' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:17:33.3800000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)

-- Role Claims
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'752ae5b8-e34f-4b32-81f2-2cf709881663', N'2e3c07a4-fcac-4303-ae47-0d0f796403c9', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Email_Edit_SMTP_Setting', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'cd46a3a4-ede5-4941-a49b-3df7eaa46428', N'5a5f7cf8-21a6-434a-9330-db91b17d867c', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Document_Category_Edit_Category', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'18a5a8f6-7cb6-4178-857d-b6a981ea3d4f', N'090ea443-01c7-4638-a194-ad3416a5ea7a', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Role_Delete_Role', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'db8825b1-ee4e-49f6-9a08-b0210ed53fd4', N'090ea443-01c7-4638-a194-ad3416a5ea7a', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Role_Create_Role', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'c288b5d3-419d-4dc0-9e5a-083194016d2c', N'090ea443-01c7-4638-a194-ad3416a5ea7a', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Role_Edit_Role', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'374d74aa-a580-4928-848d-f7553db39914', N'324bdc51-d71f-4f80-9f28-a30e8aae4009', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'User_Delete_User', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'0a2e19fc-d9f2-446c-8ca3-e6b8b73b5f9b', N'324bdc51-d71f-4f80-9f28-a30e8aae4009', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'User_Edit_User', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'86ce1382-a2b1-48ed-ae81-c9908d00cf3b', N'324bdc51-d71f-4f80-9f28-a30e8aae4009', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'User_Create_User', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'fbe77c07-3058-4dbe-9d56-8c75dc879460', N'324bdc51-d71f-4f80-9f28-a30e8aae4009', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'User_Assign_User_Role', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'd4d724fc-fd38-49c4-85bc-73937b219e20', N'324bdc51-d71f-4f80-9f28-a30e8aae4009', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'User_Reset_Password', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'e506ec48-b99a-45b4-9ec9-6451bc67477b', N'324bdc51-d71f-4f80-9f28-a30e8aae4009', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'User_Assign_Permission', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'1c7d3e31-08ad-43cf-9cf7-4ffafdda9029', N'2396f81c-f8b5-49ac-88d1-94ed57333f49', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Document_Audit_Trail_View_Document_Audit_Trail', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'ff4b3b73-c29f-462a-afa4-94a40e6b2c4a', N'f042bbee-d15f-40fb-b79a-8368f2c2e287', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Login_Audit_View_Login_Audit_Logs', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'67ae2b97-b24e-41d5-bf39-56b2834548d0', N'5a5f7cf8-21a6-434a-9330-db91b17d867c', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Document_Category_Create_Category', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'5ea48d56-2ed3-4239-bb90-dd4d70a1b0b2', N'97ff6eb0-39b3-4ddd-acf1-43205d5a9bb3', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Reminder_Delete_Reminder', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'6bc0458e-22f5-4975-b387-4d6a4fb35201', N'97ff6eb0-39b3-4ddd-acf1-43205d5a9bb3', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Reminder_Create_Reminder', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'7ba630ca-a9d3-42ee-99c8-766e2231fec1', N'42e44f15-8e33-423a-ad7f-17edc23d6dd3', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Dashboard_View_Dashboard', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'2ea6ba08-eb36-4e34-92d9-f1984c908b31', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'All_Documents_Share_Document', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'a8dd972d-e758-4571-8d39-c6fec74b361b', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'All_Documents_Edit_Document', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'6719a065-8a4a-4350-8582-bfc41ce283fb', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'All_Documents_Download_Document', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'239035d5-cd44-475f-bbc5-9ef51768d389', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'All_Documents_Create_Document', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'3da78b4d-d263-4b13-8e81-7aa164a3688c', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'All_Documents_Add_Reminder', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'595a769d-f7ef-45f3-9f9e-60c58c5e1542', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'All_Documents_Send_Email', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'4f19045b-e9a8-403b-b730-8453ee72830e', N'2e3c07a4-fcac-4303-ae47-0d0f796403c9', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Email_Delete_SMTP_Setting', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'ab0544d7-2276-4f3b-b450-7f0fa11c3dd9', N'2e3c07a4-fcac-4303-ae47-0d0f796403c9', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Email_Create_SMTP_Setting', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'3ccaf408-8864-4815-a3e0-50632d90bcb6', N'97ff6eb0-39b3-4ddd-acf1-43205d5a9bb3', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Reminder_Edit_Reminder', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'd8f12d11-aa74-49b1-9bce-f945517bffde', N'5a5f7cf8-21a6-434a-9330-db91b17d867c', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Document_Category_Delete_Category', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'ab45ef6a-a8e6-47ef-a182-6b88e2a6f9aa', N'5a5f7cf8-21a6-434a-9330-db91b17d867c', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Document_Category_View_Categories', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'57216dcd-1a1c-4f94-a33d-83a5af2d7a46', N'090ea443-01c7-4638-a194-ad3416a5ea7a', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Role_View_Roles', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'31cb6438-7d4a-4385-8a34-b4e8f6096a48', N'324bdc51-d71f-4f80-9f28-a30e8aae4009', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'User_View_Users', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'6f2717fc-edef-4537-916d-2d527251a5c1', N'97ff6eb0-39b3-4ddd-acf1-43205d5a9bb3', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Reminder_View_Reminders', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'63ed1277-1db5-4cf7-8404-3e3426cb4bc5', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'All_Documents_View_Documents', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'41f65d07-9023-4cfb-9c7c-0e3247a012e0', N'2e3c07a4-fcac-4303-ae47-0d0f796403c9', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Email_View_SMTP_Settings', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'7ba630ca-a9d3-42ee-99c8-766e2231fec1', N'42e44f15-8e33-423a-ad7f-17edc23d6dd3', N'c5d235ea-81b4-4c36-9205-2077da227c0a', N'Dashboard_View_Dashboard', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'ab45ef6a-a8e6-47ef-a182-6b88e2a6f9aa', N'5a5f7cf8-21a6-434a-9330-db91b17d867c', N'c5d235ea-81b4-4c36-9205-2077da227c0a', N'Document_Category_View_Categories', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'239035d5-cd44-475f-bbc5-9ef51768d389', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', N'c5d235ea-81b4-4c36-9205-2077da227c0a', N'Assigned_Documents_Create_Document', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'239035d5-cd44-475f-bbc5-9ef51768d389', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Assigned_Documents_Create_Document', N'')

-- ScreenOperations
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'6adf6012-0101-48b2-ad54-078d2f7fe96d', N'31cb6438-7d4a-4385-8a34-b4e8f6096a48', N'324bdc51-d71f-4f80-9f28-a30e8aae4009', CAST(N'2021-12-22T17:10:15.7372916' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T17:10:15.7400000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'f54926e2-3ad3-40be-8f7e-14cab77e87bd', N'3ccaf408-8864-4815-a3e0-50632d90bcb6', N'97ff6eb0-39b3-4ddd-acf1-43205d5a9bb3', CAST(N'2021-12-22T16:21:45.5996626' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:21:45.6000000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'87089dd2-149a-49c4-931c-18b47e08561c', N'd4d724fc-fd38-49c4-85bc-73937b219e20', N'324bdc51-d71f-4f80-9f28-a30e8aae4009', CAST(N'2021-12-22T16:21:35.8791295' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:21:35.8800000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'8e82fe1f-8ccd-4cc2-b1ca-1a84dd17a5ab', N'67ae2b97-b24e-41d5-bf39-56b2834548d0', N'5a5f7cf8-21a6-434a-9330-db91b17d867c', CAST(N'2021-12-22T16:21:05.3807145' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:21:05.3800000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'6a048b38-5b3a-42b0-83fd-2c4d588d0b2f', N'6bc0458e-22f5-4975-b387-4d6a4fb35201', N'97ff6eb0-39b3-4ddd-acf1-43205d5a9bb3', CAST(N'2021-12-22T16:21:44.7181855' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:21:44.7200000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'faf1cb6f-9c20-4ca3-8222-32028b44e484', N'595a769d-f7ef-45f3-9f9e-60c58c5e1542', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', CAST(N'2021-12-22T16:20:43.0046514' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:20:43.0033333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'65dfed53-7855-46f5-ab93-3629fc68ea71', N'1c7d3e31-08ad-43cf-9cf7-4ffafdda9029', N'2396f81c-f8b5-49ac-88d1-94ed57333f49', CAST(N'2021-12-22T16:21:14.2760682' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:21:14.2800000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'761032d2-822a-4274-ab85-3b389f5ec252', N'2ea6ba08-eb36-4e34-92d9-f1984c908b31', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', CAST(N'2021-12-22T16:20:42.2272333' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:20:42.2300000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'5d5e0edc-e14f-48ad-bf1d-3dfbd9ac55aa', N'db8825b1-ee4e-49f6-9a08-b0210ed53fd4', N'090ea443-01c7-4638-a194-ad3416a5ea7a', CAST(N'2021-12-22T16:21:21.0297782' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:21:21.0300000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'cc5d7643-e418-492f-bbbd-409a336dbce5', N'd8f12d11-aa74-49b1-9bce-f945517bffde', N'5a5f7cf8-21a6-434a-9330-db91b17d867c', CAST(N'2021-12-22T16:21:06.6744709' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:21:06.6800000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'c9928f1f-0702-4e37-97a7-431e5c9f819c', N'374d74aa-a580-4928-848d-f7553db39914', N'324bdc51-d71f-4f80-9f28-a30e8aae4009', CAST(N'2021-12-22T16:21:33.4580076' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:21:33.4600000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'e67675a7-cd03-4b28-bd2f-437a813686b0', N'cd46a3a4-ede5-4941-a49b-3df7eaa46428', N'5a5f7cf8-21a6-434a-9330-db91b17d867c', CAST(N'2021-12-22T16:21:06.0554216' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:21:06.0533333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'8a90c207-7752-4277-83f6-5345ed277d7a', N'57216dcd-1a1c-4f94-a33d-83a5af2d7a46', N'090ea443-01c7-4638-a194-ad3416a5ea7a', CAST(N'2021-12-22T17:09:52.9006960' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T17:09:52.9000000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'dcba14ed-cb99-44d4-8b4f-53d8f249ed20', N'3da78b4d-d263-4b13-8e81-7aa164a3688c', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', CAST(N'2021-12-22T16:20:47.1425483' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:20:47.1433333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'8f065fb5-01c7-4dea-ab19-650392338688', N'752ae5b8-e34f-4b32-81f2-2cf709881663', N'2e3c07a4-fcac-4303-ae47-0d0f796403c9', CAST(N'2021-12-22T16:22:00.6107538' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:22:00.6100000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'ff092131-a214-48c0-a8e3-68a8723840e1', N'86ce1382-a2b1-48ed-ae81-c9908d00cf3b', N'324bdc51-d71f-4f80-9f28-a30e8aae4009', CAST(N'2021-12-22T16:21:31.6462984' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:21:31.6466667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'd53f507b-c73c-435f-a4d0-69fe616b8d80', N'6f2717fc-edef-4537-916d-2d527251a5c1', N'97ff6eb0-39b3-4ddd-acf1-43205d5a9bb3', CAST(N'2021-12-22T17:10:41.8229074' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T17:10:41.8300000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'f8863c5a-4344-41cb-b1fa-83e223d6a7df', N'6719a065-8a4a-4350-8582-bfc41ce283fb', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', CAST(N'2021-12-22T16:20:48.9822259' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:20:48.9833333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'1a0a3737-ee82-46dc-a1b1-8bbc3aee23f6', N'ab0544d7-2276-4f3b-b450-7f0fa11c3dd9', N'2e3c07a4-fcac-4303-ae47-0d0f796403c9', CAST(N'2021-12-22T16:22:00.0004601' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:22:00.0000000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'e1278d04-1e53-4885-b7f3-8dd9786ee8ba', N'fbe77c07-3058-4dbe-9d56-8c75dc879460', N'324bdc51-d71f-4f80-9f28-a30e8aae4009', CAST(N'2021-12-22T16:21:36.6827083' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:21:36.6800000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'b13dc77a-32b9-4f48-96de-90539ba688fa', N'41f65d07-9023-4cfb-9c7c-0e3247a012e0', N'2e3c07a4-fcac-4303-ae47-0d0f796403c9', CAST(N'2021-12-22T17:11:05.2931233' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T17:11:05.2933333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'e99d8d8b-961c-47ad-85d8-a7b57c6a2f65', N'239035d5-cd44-475f-bbc5-9ef51768d389', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', CAST(N'2021-12-22T16:20:37.6126421' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:20:37.6133333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'4de6055c-5f81-44d8-aee2-b966fc442263', N'4f19045b-e9a8-403b-b730-8453ee72830e', N'2e3c07a4-fcac-4303-ae47-0d0f796403c9', CAST(N'2021-12-22T16:22:01.1583447' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:22:01.1566667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'cb980805-4de9-45b6-a12d-bb0f91d549cb', N'e506ec48-b99a-45b4-9ec9-6451bc67477b', N'324bdc51-d71f-4f80-9f28-a30e8aae4009', CAST(N'2021-12-22T16:21:35.0223941' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:21:35.0233333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'd886ffaa-e26f-4e27-b4e5-c3636f6422cf', N'ff4b3b73-c29f-462a-afa4-94a40e6b2c4a', N'f042bbee-d15f-40fb-b79a-8368f2c2e287', CAST(N'2021-12-22T16:21:54.0380761' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:21:54.0366667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'ecf7dc42-fc44-4d1a-b314-d1ff71878d94', N'5ea48d56-2ed3-4239-bb90-dd4d70a1b0b2', N'97ff6eb0-39b3-4ddd-acf1-43205d5a9bb3', CAST(N'2021-12-22T16:21:46.9438819' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:21:46.9433333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'23ddf867-056f-425b-99ed-d298bbd2d80f', N'0a2e19fc-d9f2-446c-8ca3-e6b8b73b5f9b', N'324bdc51-d71f-4f80-9f28-a30e8aae4009', CAST(N'2021-12-22T16:21:32.5698943' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:21:32.5700000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'f591c7be-4913-44f8-a74c-d2fc44dd5a3e', N'ab45ef6a-a8e6-47ef-a182-6b88e2a6f9aa', N'5a5f7cf8-21a6-434a-9330-db91b17d867c', CAST(N'2021-12-22T17:09:28.4063740' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T17:09:28.4100000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'b4fc0f33-0e9b-4b22-b357-d85125ba8d49', N'a8dd972d-e758-4571-8d39-c6fec74b361b', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', CAST(N'2021-12-22T16:20:39.2013274' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:20:39.2033333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'ded2da54-9077-46b4-8d2e-db69890bed25', N'63ed1277-1db5-4cf7-8404-3e3426cb4bc5', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', CAST(N'2021-12-22T17:08:44.8152974' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T17:08:44.8433333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'1a3346d9-3c8d-4ae0-9416-db9a157d20f2', N'18a5a8f6-7cb6-4178-857d-b6a981ea3d4f', N'090ea443-01c7-4638-a194-ad3416a5ea7a', CAST(N'2021-12-22T16:21:22.7469170' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:21:22.7466667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'b7d48f9a-c54c-4394-81ce-ea10aba9df87', N'239035d5-cd44-475f-bbc5-9ef51768d389', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', CAST(N'2021-12-24T10:15:31.2448701' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-24T10:15:31.2600000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'51c88956-ea5a-4934-96ba-fd09905a1b0a', N'7ba630ca-a9d3-42ee-99c8-766e2231fec1', N'42e44f15-8e33-423a-ad7f-17edc23d6dd3', CAST(N'2021-12-22T16:20:34.2980924' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:20:34.3066667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'044ceb92-87fc-41a5-93a7-ffaf096db766', N'c288b5d3-419d-4dc0-9e5a-083194016d2c', N'090ea443-01c7-4638-a194-ad3416a5ea7a', CAST(N'2021-12-22T16:21:21.8659673' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:21:21.8666667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)

-- UserRoles
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (N'1a5cf5b9-ead8-495c-8719-2d8be776f452', N'c5d235ea-81b4-4c36-9205-2077da227c0a')
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (N'4b352b37-332a-40c6-ab05-e38fcf109719', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5')


GO

CREATE PROCEDURE [dbo].[NLog_AddEntry_p] (
  @machineName nvarchar(200),
  @logged datetime,
  @level varchar(5),
  @message nvarchar(max),
  @logger nvarchar(300),
  @properties nvarchar(max),
  @callsite nvarchar(300),
  @exception nvarchar(max)
) AS
BEGIN
  INSERT INTO [dbo].[NLog] (
	[Id],
    [MachineName],
    [Logged],
    [Level],
    [Message],
    [Logger],
    [Properties],
    [Callsite],
    [Exception]
  ) VALUES (
    newid(),
    @machineName,
    GETUTCDATE(),
    @level,
    @message,
    @logger,
    @properties,
    @callsite,
    @exception
  )
  END
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20211222115010_Initial_SQL_Data', N'8.0.13');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

ALTER TABLE [UserNotifications] DROP CONSTRAINT [FK_UserNotifications_Users_CreatedBy];
GO

DROP INDEX [IX_UserNotifications_CreatedBy] ON [UserNotifications];
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20211224114705_drop foreignkey user notification', N'8.0.13');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

DECLARE @var0 sysname;
SELECT @var0 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[UserNotifications]') AND [c].[name] = N'DeletedBy');
IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [UserNotifications] DROP CONSTRAINT [' + @var0 + '];');
ALTER TABLE [UserNotifications] ALTER COLUMN [DeletedBy] uniqueidentifier NULL;
GO

DECLARE @var1 sysname;
SELECT @var1 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[SendEmails]') AND [c].[name] = N'DeletedBy');
IF @var1 IS NOT NULL EXEC(N'ALTER TABLE [SendEmails] DROP CONSTRAINT [' + @var1 + '];');
ALTER TABLE [SendEmails] ALTER COLUMN [DeletedBy] uniqueidentifier NULL;
GO

DECLARE @var2 sysname;
SELECT @var2 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Screens]') AND [c].[name] = N'ModifiedDate');
IF @var2 IS NOT NULL EXEC(N'ALTER TABLE [Screens] DROP CONSTRAINT [' + @var2 + '];');
ALTER TABLE [Screens] ADD DEFAULT (GETUTCDATE()) FOR [ModifiedDate];
GO

DECLARE @var3 sysname;
SELECT @var3 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Screens]') AND [c].[name] = N'DeletedBy');
IF @var3 IS NOT NULL EXEC(N'ALTER TABLE [Screens] DROP CONSTRAINT [' + @var3 + '];');
ALTER TABLE [Screens] ALTER COLUMN [DeletedBy] uniqueidentifier NULL;
GO

DECLARE @var4 sysname;
SELECT @var4 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[ScreenOperations]') AND [c].[name] = N'ModifiedDate');
IF @var4 IS NOT NULL EXEC(N'ALTER TABLE [ScreenOperations] DROP CONSTRAINT [' + @var4 + '];');
ALTER TABLE [ScreenOperations] ADD DEFAULT (GETUTCDATE()) FOR [ModifiedDate];
GO

DECLARE @var5 sysname;
SELECT @var5 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[ScreenOperations]') AND [c].[name] = N'DeletedBy');
IF @var5 IS NOT NULL EXEC(N'ALTER TABLE [ScreenOperations] DROP CONSTRAINT [' + @var5 + '];');
ALTER TABLE [ScreenOperations] ALTER COLUMN [DeletedBy] uniqueidentifier NULL;
GO

DECLARE @var6 sysname;
SELECT @var6 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Reminders]') AND [c].[name] = N'DeletedBy');
IF @var6 IS NOT NULL EXEC(N'ALTER TABLE [Reminders] DROP CONSTRAINT [' + @var6 + '];');
ALTER TABLE [Reminders] ALTER COLUMN [DeletedBy] uniqueidentifier NULL;
GO

DECLARE @var7 sysname;
SELECT @var7 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Operations]') AND [c].[name] = N'ModifiedDate');
IF @var7 IS NOT NULL EXEC(N'ALTER TABLE [Operations] DROP CONSTRAINT [' + @var7 + '];');
ALTER TABLE [Operations] ADD DEFAULT (GETUTCDATE()) FOR [ModifiedDate];
GO

DECLARE @var8 sysname;
SELECT @var8 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Operations]') AND [c].[name] = N'DeletedBy');
IF @var8 IS NOT NULL EXEC(N'ALTER TABLE [Operations] DROP CONSTRAINT [' + @var8 + '];');
ALTER TABLE [Operations] ALTER COLUMN [DeletedBy] uniqueidentifier NULL;
GO

DECLARE @var9 sysname;
SELECT @var9 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[EmailSMTPSettings]') AND [c].[name] = N'DeletedBy');
IF @var9 IS NOT NULL EXEC(N'ALTER TABLE [EmailSMTPSettings] DROP CONSTRAINT [' + @var9 + '];');
ALTER TABLE [EmailSMTPSettings] ALTER COLUMN [DeletedBy] uniqueidentifier NULL;
GO

DECLARE @var10 sysname;
SELECT @var10 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[DocumentUserPermissions]') AND [c].[name] = N'DeletedBy');
IF @var10 IS NOT NULL EXEC(N'ALTER TABLE [DocumentUserPermissions] DROP CONSTRAINT [' + @var10 + '];');
ALTER TABLE [DocumentUserPermissions] ALTER COLUMN [DeletedBy] uniqueidentifier NULL;
GO

DECLARE @var11 sysname;
SELECT @var11 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Documents]') AND [c].[name] = N'ModifiedDate');
IF @var11 IS NOT NULL EXEC(N'ALTER TABLE [Documents] DROP CONSTRAINT [' + @var11 + '];');
ALTER TABLE [Documents] ADD DEFAULT (GETUTCDATE()) FOR [ModifiedDate];
GO

DECLARE @var12 sysname;
SELECT @var12 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Documents]') AND [c].[name] = N'DeletedBy');
IF @var12 IS NOT NULL EXEC(N'ALTER TABLE [Documents] DROP CONSTRAINT [' + @var12 + '];');
ALTER TABLE [Documents] ALTER COLUMN [DeletedBy] uniqueidentifier NULL;
GO

DECLARE @var13 sysname;
SELECT @var13 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[DocumentRolePermissions]') AND [c].[name] = N'DeletedBy');
IF @var13 IS NOT NULL EXEC(N'ALTER TABLE [DocumentRolePermissions] DROP CONSTRAINT [' + @var13 + '];');
ALTER TABLE [DocumentRolePermissions] ALTER COLUMN [DeletedBy] uniqueidentifier NULL;
GO

DECLARE @var14 sysname;
SELECT @var14 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[DocumentAuditTrails]') AND [c].[name] = N'ModifiedDate');
IF @var14 IS NOT NULL EXEC(N'ALTER TABLE [DocumentAuditTrails] DROP CONSTRAINT [' + @var14 + '];');
ALTER TABLE [DocumentAuditTrails] ADD DEFAULT (GETUTCDATE()) FOR [ModifiedDate];
GO

DECLARE @var15 sysname;
SELECT @var15 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[DocumentAuditTrails]') AND [c].[name] = N'DeletedBy');
IF @var15 IS NOT NULL EXEC(N'ALTER TABLE [DocumentAuditTrails] DROP CONSTRAINT [' + @var15 + '];');
ALTER TABLE [DocumentAuditTrails] ALTER COLUMN [DeletedBy] uniqueidentifier NULL;
GO

DECLARE @var16 sysname;
SELECT @var16 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Categories]') AND [c].[name] = N'ModifiedDate');
IF @var16 IS NOT NULL EXEC(N'ALTER TABLE [Categories] DROP CONSTRAINT [' + @var16 + '];');
ALTER TABLE [Categories] ADD DEFAULT (GETUTCDATE()) FOR [ModifiedDate];
GO

DECLARE @var17 sysname;
SELECT @var17 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Categories]') AND [c].[name] = N'DeletedBy');
IF @var17 IS NOT NULL EXEC(N'ALTER TABLE [Categories] DROP CONSTRAINT [' + @var17 + '];');
ALTER TABLE [Categories] ALTER COLUMN [DeletedBy] uniqueidentifier NULL;
GO

CREATE TABLE [DocumentComments] (
    [Id] uniqueidentifier NOT NULL,
    [DocumentId] uniqueidentifier NOT NULL,
    [Comment] nvarchar(max) NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [ModifiedDate] datetime2 NOT NULL,
    [ModifiedBy] uniqueidentifier NOT NULL,
    [DeletedDate] datetime2 NULL,
    [DeletedBy] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_DocumentComments] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_DocumentComments_Documents_DocumentId] FOREIGN KEY ([DocumentId]) REFERENCES [Documents] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_DocumentComments_Users_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [Users] ([Id]) ON DELETE NO ACTION
);
GO

CREATE TABLE [DocumentMetaDatas] (
    [Id] uniqueidentifier NOT NULL,
    [DocumentId] uniqueidentifier NOT NULL,
    [Metatag] nvarchar(max) NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [ModifiedDate] datetime2 NOT NULL,
    [ModifiedBy] uniqueidentifier NOT NULL,
    [DeletedDate] datetime2 NULL,
    [DeletedBy] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_DocumentMetaDatas] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_DocumentMetaDatas_Documents_DocumentId] FOREIGN KEY ([DocumentId]) REFERENCES [Documents] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [DocumentVersions] (
    [Id] uniqueidentifier NOT NULL,
    [DocumentId] uniqueidentifier NOT NULL,
    [Url] nvarchar(max) NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [ModifiedDate] datetime2 NOT NULL,
    [ModifiedBy] uniqueidentifier NOT NULL,
    [DeletedDate] datetime2 NULL,
    [DeletedBy] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_DocumentVersions] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_DocumentVersions_Documents_DocumentId] FOREIGN KEY ([DocumentId]) REFERENCES [Documents] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_DocumentVersions_Users_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [Users] ([Id]) ON DELETE NO ACTION
);
GO

CREATE INDEX [IX_DocumentComments_CreatedBy] ON [DocumentComments] ([CreatedBy]);
GO

CREATE INDEX [IX_DocumentComments_DocumentId] ON [DocumentComments] ([DocumentId]);
GO

CREATE INDEX [IX_DocumentMetaDatas_DocumentId] ON [DocumentMetaDatas] ([DocumentId]);
GO

CREATE INDEX [IX_DocumentVersions_CreatedBy] ON [DocumentVersions] ([CreatedBy]);
GO

CREATE INDEX [IX_DocumentVersions_DocumentId] ON [DocumentVersions] ([DocumentId]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20220620094937_Version_V3', N'8.0.13');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

ALTER TABLE [UserNotifications] ADD [NotificationsType] int NOT NULL DEFAULT 0;
GO

ALTER TABLE [SendEmails] ADD [FromName] nvarchar(max) NULL;
GO

ALTER TABLE [SendEmails] ADD [ToName] nvarchar(max) NULL;
GO

ALTER TABLE [Screens] ADD [OrderNo] int NULL;
GO

DECLARE @var18 sysname;
SELECT @var18 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[NLog]') AND [c].[name] = N'Logged');
IF @var18 IS NOT NULL EXEC(N'ALTER TABLE [NLog] DROP CONSTRAINT [' + @var18 + '];');
UPDATE [NLog] SET [Logged] = GETUTCDATE() WHERE [Logged] IS NULL;
ALTER TABLE [NLog] ALTER COLUMN [Logged] datetime2 NOT NULL;
ALTER TABLE [NLog] ADD DEFAULT (GETUTCDATE()) FOR [Logged];
GO

ALTER TABLE [DocumentVersions] ADD [IV] VARBINARY(MAX) NULL;
GO

ALTER TABLE [DocumentVersions] ADD [Key] VARBINARY(MAX) NULL;
GO

ALTER TABLE [Documents] ADD [DocumentStatusId] uniqueidentifier NULL;
GO

ALTER TABLE [Documents] ADD [IV] VARBINARY(MAX) NULL;
GO

ALTER TABLE [Documents] ADD [Key] VARBINARY(MAX) NULL;
GO

ALTER TABLE [Documents] ADD [StorageSettingId] uniqueidentifier NULL;
GO

ALTER TABLE [Documents] ADD [StorageType] int NOT NULL DEFAULT 0;
GO

CREATE TABLE [CompanyProfiles] (
    [Id] uniqueidentifier NOT NULL,
    [Name] nvarchar(max) NULL,
    [LogoUrl] nvarchar(max) NULL,
    [BannerUrl] nvarchar(max) NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [ModifiedDate] datetime2 NOT NULL,
    [ModifiedBy] uniqueidentifier NOT NULL,
    [DeletedDate] datetime2 NULL,
    [DeletedBy] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_CompanyProfiles] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [DocumentShareableLinks] (
    [Id] uniqueidentifier NOT NULL,
    [DocumentId] uniqueidentifier NOT NULL,
    [LinkExpiryTime] datetime NULL,
    [Password] nvarchar(max) NULL,
    [LinkCode] nvarchar(max) NULL,
    [IsLinkExpired] bit NOT NULL,
    [IsAllowDownload] bit NOT NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [ModifiedDate] datetime2 NOT NULL,
    [ModifiedBy] uniqueidentifier NOT NULL,
    [DeletedDate] datetime2 NULL,
    [DeletedBy] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_DocumentShareableLinks] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_DocumentShareableLinks_Documents_DocumentId] FOREIGN KEY ([DocumentId]) REFERENCES [Documents] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [DocumentStatuses] (
    [Id] uniqueidentifier NOT NULL,
    [Name] nvarchar(max) NULL,
    [Description] nvarchar(max) NULL,
    [ColorCode] nvarchar(max) NULL,
    CONSTRAINT [PK_DocumentStatuses] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [PageHelpers] (
    [Id] uniqueidentifier NOT NULL,
    [Code] nvarchar(max) NULL,
    [Name] nvarchar(max) NULL,
    [Description] nvarchar(max) NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [ModifiedDate] datetime2 NOT NULL,
    [ModifiedBy] uniqueidentifier NOT NULL,
    [DeletedDate] datetime2 NULL,
    [DeletedBy] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_PageHelpers] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [StorageSettings] (
    [Id] uniqueidentifier NOT NULL,
    [Name] nvarchar(max) NULL,
    [JsonValue] nvarchar(max) NULL,
    [IsDefault] bit NOT NULL,
    [EnableEncryption] bit NOT NULL,
    [StorageType] int NOT NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [ModifiedDate] datetime2 NOT NULL,
    [ModifiedBy] uniqueidentifier NOT NULL,
    [DeletedDate] datetime2 NULL,
    [DeletedBy] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_StorageSettings] PRIMARY KEY ([Id])
);
GO

CREATE INDEX [IX_Documents_DocumentStatusId] ON [Documents] ([DocumentStatusId]);
GO

CREATE INDEX [IX_Documents_StorageSettingId] ON [Documents] ([StorageSettingId]);
GO

CREATE INDEX [IX_DocumentShareableLinks_DocumentId] ON [DocumentShareableLinks] ([DocumentId]);
GO

ALTER TABLE [Documents] ADD CONSTRAINT [FK_Documents_DocumentStatuses_DocumentStatusId] FOREIGN KEY ([DocumentStatusId]) REFERENCES [DocumentStatuses] ([Id]);
GO

ALTER TABLE [Documents] ADD CONSTRAINT [FK_Documents_StorageSettings_StorageSettingId] FOREIGN KEY ([StorageSettingId]) REFERENCES [StorageSettings] ([Id]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20241009055439_Version_V31', N'8.0.13');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

--CompanyProfiles
INSERT [dbo].[CompanyProfiles] ([Id], [Name], [LogoUrl], [BannerUrl], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'5bf73f1d-4679-4901-b833-7963b2799f33', N'Document Mangement', N'logo.png', N'banner.png', CAST(N'2024-10-01T12:39:07.6685564' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-01T12:39:07.6685565' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)

--StorageSettings
INSERT [dbo].[StorageSettings] ([Id], [Name], [JsonValue], [IsDefault], [StorageType], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted], [EnableEncryption]) VALUES (N'06890479-e463-4f40-a9a0-080c03e3f7a4', N'Local Storage', NULL, 1, 2, CAST(N'2024-09-30T14:16:38.7395207' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-09-30T14:16:38.7395209' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0, 0)

--Screens
INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsDeleted], [OrderNo]) VALUES (N'FC1D752F-005B-4CAE-9303-B7557EEE7461', N'Storage Settings', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', 0,10)
INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsDeleted], [OrderNo]) VALUES (N'669C82F1-0DE0-459C-B62A-83A9614259E4', N'Company Profile', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', 0,11)
INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsDeleted], [OrderNo]) VALUES (N'4513EAE1-373A-4734-928C-8943C3F070BB', N'Document Status', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', 0,12)

INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsDeleted], [OrderNo]) VALUES (N'73DF018E-77B1-42FB-B8D7-D7A09836E453', N'Page Helper', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', 0, 14)
INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsDeleted], [OrderNo]) VALUES (N'42338E4F-05E0-48D1-862A-D977C39D02DF', N'Error Logs', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', 0, 15)

--Operations
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsDeleted]) VALUES (N'64E4EC29-5280-4CED-A196-3B95D2FC5C68', N'Manage Storage Settings', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsDeleted]) VALUES (N'432B3A42-9FB5-48C1-A6FB-2ADF40B650D0', N'Manage Company Settings', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsDeleted]) VALUES (N'508DECA4-61DE-426F-AB1E-47A4A30DFD24', N'Manage Document Status', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsDeleted]) VALUES (N'F0BD06DA-4E1B-41BC-ABB0-AC833392C880', N'Create Shareable Link', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsDeleted]) VALUES (N'3CA8F8CD-0DEC-4079-A3EB-6F48D1788283', N'Add Comment', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsDeleted]) VALUES (N'4C9DBF32-7608-469A-BFFF-12DC83B00912', N'Delete Comment', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsDeleted]) VALUES (N'0AAAFAF0-CE63-4055-9204-DB4B03160CDE', N'Upload New version', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsDeleted]) VALUES (N'1E2453BD-A1CD-4E8F-B5B3-7C536CE7FED5', N'View version history', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsDeleted]) VALUES (N'E3EBB06C-1D2C-4FA8-A3E8-612ADA02D4AE', N'Restore version', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', 0)

INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsDeleted]) VALUES (N'AD313C14-ABE8-4557-8989-CE6243BCD9CE', N'Manage Page Helper', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsDeleted]) VALUES (N'D2468BFC-15EB-4C80-8A3C-582C4811EC4D', N'View Error Logs', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', 0)


--ScreenOperations
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'FC1D752F-005B-4CAE-9303-B7557EEE7461', N'64E4EC29-5280-4CED-A196-3B95D2FC5C68', N'FC1D752F-005B-4CAE-9303-B7557EEE7461', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'61C15E32-28A9-4DCE-8CDE-5CA8325F5F04', N'432B3A42-9FB5-48C1-A6FB-2ADF40B650D0', N'669C82F1-0DE0-459C-B62A-83A9614259E4', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'77B6DC42-AECE-4FDB-8203-06B61C2DDDB0', N'508DECA4-61DE-426F-AB1E-47A4A30DFD24', N'4513EAE1-373A-4734-928C-8943C3F070BB', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'70826821-6FEE-4BF2-A64D-49CD41E7823D', N'F0BD06DA-4E1B-41BC-ABB0-AC833392C880', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'6E52219E-0B7F-4E57-B7B3-DB688DE17AF0', N'F0BD06DA-4E1B-41BC-ABB0-AC833392C880', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'616254DE-2EA2-46E3-B7C3-4596D6180144', N'3CA8F8CD-0DEC-4079-A3EB-6F48D1788283', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'74BDCA6C-DDF5-49A6-9719-F364AB7BEE11', N'0AAAFAF0-CE63-4055-9204-DB4B03160CDE', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'63B2165E-CB49-4F10-B504-082F618B76F0', N'1E2453BD-A1CD-4E8F-B5B3-7C536CE7FED5', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'B0081952-68C8-4C89-83B1-3D5C97941C19', N'E3EBB06C-1D2C-4FA8-A3E8-612ADA02D4AE', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'B470AE88-E223-45DE-8720-3D4467A5F702', N'4C9DBF32-7608-469A-BFFF-12DC83B00912', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'197C97B0-BD33-4E2E-8C1E-BCCFD1C65FBD', N'4C9DBF32-7608-469A-BFFF-12DC83B00912', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'01CE3C47-67A7-4FAE-821A-494BFF0D46EF', N'3CA8F8CD-0DEC-4079-A3EB-6F48D1788283', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'DF81DECD-4282-4873-9606-AB353FCC4523', N'3da78b4d-d263-4b13-8e81-7aa164a3688c', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'A2148F30-0A60-420E-992A-C93B4B297DF8', N'1E2453BD-A1CD-4E8F-B5B3-7C536CE7FED5', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)

INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'2A9169A8-A46E-4D61-94FC-AA8A9ADC459A', N'AD313C14-ABE8-4557-8989-CE6243BCD9CE', N'73DF018E-77B1-42FB-B8D7-D7A09836E453', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'D21077FE-3441-4AD2-BD22-BD13233EE5B2', N'D2468BFC-15EB-4C80-8A3C-582C4811EC4D', N'42338E4F-05E0-48D1-862A-D977C39D02DF', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)


INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'4C9DBF32-7608-469A-BFFF-12DC83B00912', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Assigned_Documents_Delete_Comment', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'3CA8F8CD-0DEC-4079-A3EB-6F48D1788283', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Assigned_Documents_Add_Comment', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'3da78b4d-d263-4b13-8e81-7aa164a3688c', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Assigned_Documents_Add_Reminder', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'1E2453BD-A1CD-4E8F-B5B3-7C536CE7FED5', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Assigned_Documents_View_version_history', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'F0BD06DA-4E1B-41BC-ABB0-AC833392C880', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Assigned_Documents_Create_Shareable_Link', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'4C9DBF32-7608-469A-BFFF-12DC83B00912', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Assigned_Documents_Create_Delete_Comment', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'E3EBB06C-1D2C-4FA8-A3E8-612ADA02D4AE', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Assigned_Documents_Create_Restore_version', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'3CA8F8CD-0DEC-4079-A3EB-6F48D1788283', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Assigned_Documents_Create_Add_Comment', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'1E2453BD-A1CD-4E8F-B5B3-7C536CE7FED5', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Assigned_Documents_View_version_history', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'F0BD06DA-4E1B-41BC-ABB0-AC833392C880', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Assigned_Documents_Create_Shareable_Link', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'0AAAFAF0-CE63-4055-9204-DB4B03160CDE', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Assigned_Documents_Upload_New_version', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'508DECA4-61DE-426F-AB1E-47A4A30DFD24', N'4513EAE1-373A-4734-928C-8943C3F070BB', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Document_Status_Manage_Document_Status', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'64E4EC29-5280-4CED-A196-3B95D2FC5C68', N'FC1D752F-005B-4CAE-9303-B7557EEE7461', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Storage_Settings_Manage_Storage_Settings', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'432B3A42-9FB5-48C1-A6FB-2ADF40B650D0', N'669C82F1-0DE0-459C-B62A-83A9614259E4', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Company_Profile_Manage_Company_Settings', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'AD313C14-ABE8-4557-8989-CE6243BCD9CE', N'73DF018E-77B1-42FB-B8D7-D7A09836E453', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Page_Helper_Manage_Page_Helper', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES (N'D2468BFC-15EB-4C80-8A3C-582C4811EC4D', N'42338E4F-05E0-48D1-862A-D977C39D02DF', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Error_Logs_View_Error_Logs', N'')

--Screen Order
Update Screens set OrderNo = 1 where name = 'Dashboard'
Update Screens set OrderNo = 2 where name = 'Assigned Documents'
Update Screens set OrderNo = 3 where name = 'All Documents'
Update Screens set OrderNo = 4 where name = 'Document Status'
Update Screens set OrderNo = 5 where name = 'Document Category'
Update Screens set OrderNo = 6 where name = 'Document Audit Trail'
Update Screens set OrderNo = 7 where name = 'Role'
Update Screens set OrderNo = 8 where name = 'User'
Update Screens set OrderNo = 9 where name = 'Reminder'
Update Screens set OrderNo = 10 where name = 'Storage Settings'
Update Screens set OrderNo = 11 where name = 'Company Profile'
Update Screens set OrderNo = 12 where name = 'Email'
Update Screens set OrderNo = 13 where name = 'Login Audit'

INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'8fd8c3c6-ac6e-45d8-9757-00300fc9ca8f', N'DOCUMENT_STATUS', N'Document Status', N'<p>Users can add, edit, and view a list of document statuses. Each status includes three customizable fields: name, description, and a unique colour code for easy identification and organization of documents.</p><h4><strong>Main Components:</strong></h4><p><strong>"Add New Document Status" Button:</strong></p><p>Allows administrators or users with appropriate permissions to create a new status.</p><ul><li><strong>List of Existing Statuses:</strong></li><li>Displays all the Statuses created within the system.</li><li>Each entry includes the status name, description and unique colour code for easy identification and organization of documents.</li><li><strong>Action Menu for Each Status:</strong></li><li>Next to each status, users will find action options that allow them to manage the category:<ul><li><strong>Edit:</strong> Enables modification of the status''s details, such as the name or description, and unique colour code .</li><li><strong>Delete:</strong> Removes the status from the system. This action may require confirmation to prevent accidental deletions.</li></ul></li></ul>', CAST(N'2023-06-03T05:22:43.7270890' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-10-05T07:18:42.0522139' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'eccba93d-48bb-48f6-9784-14968d8843c8', N'MANAGE_USER', N'Manage User', N'<p>The User Information page is designed to collect and manage your personal details. This page is essential for setting up your user profile and ensuring you have a seamless experience using our application. Below is a brief overview of the fields you will encounter:</p><h4><strong>Fields on the User Information Page</strong></h4><ol><li><strong>First Name</strong>:<ul><li><strong>What it is</strong>: Your given name.</li><li><strong>Importance</strong>: Helps us address you properly within the application.</li></ul></li><li><strong>Last Name</strong>:<ul><li><strong>What it is</strong>: Your family name or surname.</li><li><strong>Importance</strong>: Completes your identity and is often required for official documents.</li></ul></li><li><strong>Mobile Number</strong>:<ul><li><strong>What it is</strong>: Your phone number.</li><li><strong>Importance</strong>: Used for account recovery, notifications, and two-factor authentication. It’s optional but recommended for security purposes.</li></ul></li><li><strong>Email Address</strong>:<ul><li><strong>What it is</strong>: Your electronic mail address.</li><li><strong>Importance</strong>: Serves as your primary communication channel with us. It’s required for account verification, notifications, and password recovery.</li></ul></li><li><strong>Password</strong>:<ul><li><strong>What it is</strong>: A secret word or phrase you create to secure your account.</li><li><strong>Importance</strong>: Protects your account from unauthorized access. It must be at least 6 characters long.</li></ul></li><li><strong>Confirm Password</strong>:<ul><li><strong>What it is</strong>: A second entry of your chosen password.</li><li><strong>Importance</strong>: Ensures you’ve entered your password correctly.</li></ul></li><li><strong>Role</strong>:<ul><li><strong>What it is</strong>: Your assigned position or function within the application (e.g., Admin, User, Editor).</li><li><strong>Importance</strong>: Determines your access level and permissions within the application. This field is required to define your responsibilities and capabilities.</li></ul></li></ol><h4><strong>How to Use the Page</strong></h4><ul><li><strong>Filling Out the Form</strong>:<ul><li>Enter your information in the required fields.</li><li>Ensure that your password and confirm password entries match to avoid any errors.</li></ul></li><li><strong>Submitting Your Information</strong>:<ul><li>Once you have filled in all required fields, click the "Submit" button.</li><li>If any required fields are left blank or contain errors, you will see helpful messages prompting you to correct them.</li></ul></li><li><strong>Visual Feedback</strong>:<ul><li>Fields that require your attention will be highlighted, and error messages will guide you in making the necessary corrections.</li></ul></li></ul>', CAST(N'2023-06-03T05:22:22.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'a1c28412-9590-4cdb-b7a0-1687e890ad5d', N'ADD_REMINDER', N'Add reminder', N'<p><strong>The "Add Reminder" functionality in the "Manage Reminders" section allows users to create reminders or notifications related to specific events or tasks. These reminders can be customized according to the user''s needs and can be sent to specific other users.</strong></p><p><strong>Components and Features:</strong></p><ul><li><strong>Subject:</strong> This field allows the user to enter a title or theme for the reminder. This will be the main subject of the notification.</li><li><strong>Message:</strong> Here, users can add additional details or information related to the reminder. This can be a descriptive message or specific instructions.</li><li><strong>Repeat Reminder:</strong> This option allows setting the frequency with which the reminder will be repeated, such as daily, weekly, or monthly.</li><li><strong>Send Email:</strong> If this option is enabled, the reminder will also be sent as an email to the selected users.</li><li><strong>Select Users:</strong> This field allows the selection of users to whom the reminder will be sent. Users can be selected individually or in groups.</li><li><strong>Reminder Date:</strong> This is the time at which the reminder will be activated and sent to the selected users.</li></ul><p><strong>How to Add a New Reminder:</strong></p><ul><li>Go to the "Manage Reminders" section.</li><li>Click the "Add Reminder" button.</li><li>Fill in all required fields with the desired information.</li><li>After entering all the details, click "Save" or "Confirm" to add the reminder to the system.</li></ul>', CAST(N'2023-06-03T05:09:44.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-10-05T05:17:00.0249145' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'2b728c10-c0b3-451e-8d08-2be1e3f6d5b3', N'USERS', N'Users', N'<p><strong>The "Users" page is the central hub for managing all registered users in CMR DMS. Here, administrators can add, edit, or delete users, as well as manage permissions and reset passwords. Each user has associated details such as first name, last name, mobile phone number, and email address.</strong></p><p><strong>Main Components:</strong></p><ul><li><p><strong>"Add User" Button:</strong> Allows administrators to create a new user in the system.</p><p>Opens a form where details such as first name, last name, mobile phone number, email address, password, and password confirmation can be entered.</p></li><li><p><strong>List of Existing Users:</strong> Displays all registered users in the system in a tabular format.</p><p>Each entry includes the user’s email address, first name, last name, and mobile phone number.</p><p>Next to each user, there is an action menu represented by three vertical dots.</p></li><li><p><strong>Action Menu for Each User:</strong> This menu opens by clicking on the three vertical dots next to each user.</p><p>Includes the options:</p><ul><li><strong>Edit:</strong> Allows modification of the user’s details.</li><li><strong>Delete:</strong> Removes the user from the system. This action may require confirmation to prevent accidental deletions.</li><li><strong>Permissions:</strong> Opens a window or form where administrators can set or modify the user’s permissions.</li><li><strong>Reset Password:</strong> Allows administrators to initiate a password reset process for the selected user.</li></ul></li></ul><p><strong>How to Add a New User:</strong></p><ol><li>Click on the "Add User" button.</li><li>A form will open where you can enter the user’s details: first name, last name, mobile phone number, email address, password, and password confirmation.</li><li>After completing the details, click "Save" or "Add" to add the user to the system.</li></ol>', CAST(N'2023-06-03T05:21:00.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-10-04T14:17:56.5874730' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'f5cecacd-f0e6-45b3-8de2-348d8ec29556', N'LOGIN_AUDIT_LOGS', N'Audit logs', N'<p><strong>The "Login Audit Logs" page serves as a centralized record for all authentication activities within CMR DMS. Here, administrators can monitor and review all login attempts, successful or failed, made by users. This provides a clear perspective on system security and user activities.</strong></p><p><strong>Main Components:</strong></p><ul><li><p><strong>Authentication Logs Table:</strong> Displays all login entries in a tabular format.</p><p>Each entry includes details such as the username, login date and time, the IP address from which the login was made, and the result (success/failure).</p></li></ul><p><strong>How to View Log Entries:</strong></p><ol><li>Navigate to the "Login Audit Logs" page.</li><li>Browse through the table to view all login entries.</li><li>Use the search or filter function, if available, to find specific entries.</li></ol>', CAST(N'2023-06-03T05:25:13.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-10-04T14:20:41.4415623' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'5d15d912-674b-47af-ade8-35013e4c95c4', N'DOCUMENT_COMMENTS', N'Comments', N'<ul><li><strong>Allows users to add comments to the document.</strong></li><li>Other users can view and respond to comments, facilitating discussion and collaboration on the document.</li></ul>', CAST(N'2023-06-03T05:14:57.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-10-04T14:21:21.7475706' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'ab28cf5c-0d89-4a52-a87b-359106897cba', N'MANAGE_EMAIL_SMTP_SETTING', N'Manage Email SMTP Setting', N'<p>The <strong>"Email SMTP Settings"</strong> page within CMR DMS allows administrators to configure and manage the SMTP settings for sending emails. This ensures that emails sent from the system are correctly and efficiently delivered to recipients.</p><p><strong>Key Components:</strong></p><ul><li><p><strong>SMTP Settings Table:</strong> Displays all configured SMTP settings in a tabular format.</p><p>Each entry in the table includes details such as the username, host, port, and whether that configuration is set as the default.</p></li><li><p><strong>"Add Settings" Button:</strong> Allows administrators to add a new SMTP configuration.</p><p>Clicking the button opens a form where details like username, host, port, and the option to set it as the default configuration can be entered.</p></li></ul><p><strong>"Add Settings" Form:</strong></p><p>This form opens when administrators click the "Add Settings" button and includes the following fields:</p><ul><li><strong>Username:</strong> The username required for authentication on the SMTP server.</li><li><strong>Host:</strong> The SMTP server address.</li><li><strong>Port:</strong> The port on which the SMTP server listens.</li><li><strong>Is Default:</strong> A checkbox that allows setting this configuration as the default for sending emails.</li></ul><p><strong>How to Add a New SMTP Configuration:</strong></p><ol><li>Click the "Add Settings" button.</li><li>The "Add Settings" form will open, where you can enter the SMTP configuration details.</li><li>Fill in the necessary fields and select the desired options.</li><li>After completing the details, click "Save" or "Add" to add the configuration to the system.</li></ol>', CAST(N'2023-06-03T05:27:13.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'8c1e5b05-0d7e-45cc-973d-423b2e10c5fd', N'SHARE_DOCUMENT', N'Share Document', N'<h4>Overview</h4><p>The <strong>Share Document</strong> feature allows users to assign access permissions to specific documents for individual users or user roles, with the ability to manage these permissions effectively. Users can also remove existing permissions, enhancing collaboration and control over document access.</p><h4>Features</h4><ol><li><strong>Assign By Users and Assign By Roles</strong><ul><li><strong>Buttons:</strong><ul><li>Two separate buttons are available at the Top of the share document section:<ul><li><strong>Assign By Users:</strong> Opens a dialog for selecting individual users to share the document with.</li><li><strong>Assign By Roles:</strong> Opens a dialog for selecting user roles to share the document with.</li></ul></li></ul></li><li><strong>User/Roles List:</strong><ul><li>Below the buttons, a list displays users or roles who currently have document permissions, including details such as:</li><li>Delete Button( Allow to delete existing permission to user or role)<ul><li>User/Role Name</li><li>Type (User/Role)</li><li>Allow Download(if applicable)</li><li>Email(if applicable)</li><li>Start Date (if applicable)</li><li>End Date (if applicable)</li><li>&nbsp;</li><li><strong>Delete Button:</strong> A delete button next to each user/role in the list, allowing for easy removal of permissions.</li></ul></li></ul></li></ul></li><li><strong>Dialog for Selection</strong><ul><li><strong>Dialog Features:</strong><ul><li>Upon clicking either <strong>Assign By Users</strong> or <strong>Assign By Roles</strong>, a dialog opens with the following features:<ul><li><strong>User/Role Selection:</strong><ul><li>A multi-select dropdown list allows users to select multiple users or roles for sharing the document.</li></ul></li><li><strong>Additional Options:</strong><ul><li><strong>Share Duration:</strong> Users can specify a time period for which the document will be accessible (e.g., start date and end date). </li><li><strong>Allow Download:</strong> A checkbox option that allows users to enable or disable downloading of the document.</li><li><strong>Allow Email Notification:</strong>A checkbox option that, when checked, sends an email notification to the selected users/roles.<ul><li>If this option is selected, SMTP configuration must be set up in the application. If SMTP is not configured, an error message will display informing the user of the missing configuration.</li></ul></li></ul></li></ul></li></ul></li></ul></li><li><strong>Saving Shared Document Permissions</strong><ul><li><strong>Save Button:</strong><ul><li>A <strong>Save</strong> button within the dialog allows users to save the selected permissions.</li></ul></li><li><strong>Reflection of Changes:</strong><ul><li>Upon saving, the data is updated, and the list at the bottom of the main interface reflects the newly shared document permissions, showing:<ul><li>User/Role Name</li><li>Type (User/Role)</li><li>Allow Download(if applicable)</li><li>Email(if applicable)</li><li>Start Date (if applicable)</li><li>End Date (if applicable)</li><li>Whether download and email notification options are enabled</li></ul></li></ul></li></ul></li><li><strong>Removing Shared Permissions</strong><ul><li><strong>Delete Button Functionality:</strong><ul><li>Users can click the <strong>Delete</strong> button next to any user or role in the existing shared permissions list.</li><li><strong>Confirmation Dialog:</strong> A confirmation prompt appears to ensure that users intend to remove the selected permission. Users must confirm the action to proceed.</li></ul></li><li><strong>Updating the List:</strong><ul><li>Once confirmed, the shared permission for the selected user or role is removed from the list, and the list updates immediately to reflect this change.</li></ul></li></ul></li><li><strong>User Interaction Flow</strong><ul><li><strong>Navigating to Share Document:</strong><ul><li>Users access the <strong>Share Document</strong> section within the application.</li></ul></li><li><strong>Assigning Permissions:</strong><ul><li>Users click on <strong>Assign By Users</strong> or <strong>Assign By Roles</strong> to open the respective dialog.</li><li>They select the appropriate users or roles, configure additional options, and click <strong>Save</strong>.</li></ul></li><li><strong>Removing Permissions:</strong><ul><li>Users can remove permissions by clicking the <strong>Delete</strong> button next to an entry in the shared permissions list and confirming the action.</li></ul></li><li><strong>Reviewing Shared Permissions:</strong><ul><li>The updated list displays the current permissions, allowing users to verify and manage document sharing effectively.</li></ul></li></ul></li></ol><h3>Summary</h3><p>The <strong>Share Document</strong> functionality provides a structured interface for assigning and managing document permissions to individual users or roles, with added flexibility to remove existing permissions. This feature enhances document collaboration and control while ensuring users can efficiently manage access. The inclusion of SMTP configuration checks for email notifications adds robustness to the communication aspect of the document-sharing process.</p>', CAST(N'2023-06-03T05:22:43.7270890' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-10-05T09:44:36.7243227' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'f6a1faa6-7245-4f9f-ad17-5478677bedfb', N'DOCUMENTS_BY_CATEGORY', N'Documents by category', N'<p>The <strong>Homepage</strong> provides an overview of the documents within the system, showcasing statistics related to the number of documents organized by category. It is the ideal place to quickly obtain a clear view of the volume and distribution of documents in the DMS.</p><h3>Main Components:</h3><ol><li><strong>Document Statistics</strong>:<ul><li>Displays a numerical summary of all the documents in the system, organized by category.</li><li>Each category is accompanied by a number indicating how many documents are in that category.</li></ul></li><li><strong>"Document Categories" List</strong>:<ul><li>Shows the different document categories available in the system, such as:<ul><li>"Professional-Scientific_and_Education"</li><li>"HR Policies 2021"</li><li>"Professional1"</li><li>"Initial Complaint"</li><li>"HR Policies 2020"</li><li>"Studies_and_Strategies"</li><li>"Administrative_and_Financial"</li><li>"Approvals"</li><li>"Jurisdiction Commission"</li></ul></li><li>Next to each category, the number of documents is displayed, providing a clear view of the document distribution across categories.</li></ul></li></ol><h3>How to interpret the statistics:</h3><ol><li>Navigate to the <strong>Statistics</strong> section on the <strong>Homepage</strong>.</li><li>View the total number of documents for each category.<ul><li>These numbers give you an idea of the volume of documents in each category and help identify which categories have the most or fewest documents.</li></ul></li></ol>', CAST(N'2023-06-02T17:29:40.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-10-05T04:44:20.2555490' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'5d7ba1b1-a380-4e4d-8cb0-56159a6ee0d3', N'ASSIGNED_DOCUMENTS', N'Assigned documents', N'<p>The <strong>"Assigned Documents"</strong> page is the central hub for managing documents allocated to a specific user. Here, users can view all the documents assigned to them, search for specific documents, and perform various actions on each document.</p><h3>Main Components:</h3><ul><li><strong>"Add Document" Button</strong>: Allows users to upload a new document to the system.<ul><li>Opens a form or pop-up window where files can be selected and uploaded.</li></ul></li><li><strong>My Reminders</strong>: Displays a list of all the reminders set by the user.<ul><li>Users can view, edit, or delete reminders.</li></ul></li><li><strong>Search Box (by name or document)</strong>: Allows users to search for a specific document by entering its name or other document details.</li><li><strong>Search Box (by meta tags)</strong>: Users can enter meta tags to filter and search for specific documents.</li><li><strong>Category Selection Dropdown</strong>: A dropdown menu that allows users to filter documents based on their category.</li><li><strong>Status Selection Dropdown</strong>: A dropdown menu that allows users to filter documents based on their status.</li><li><strong>List of files allocated to the user</strong>: Displays the documents assigned to the user in allocation order.<ul><li>Each entry includes columns for "Action," "Name," "Status," "Category Name," "Creation Date," "Expiration Date," and "Created By."</li></ul></li><li>Next to each document, there is a menu with options such as "edit," "share," "view," "upload a version," "version history," "comment," and "add reminder."</li></ul><h3>How to Add a New Document:</h3><ol><li>Click the <strong>"Add Document"</strong> button.</li><li>A form or pop-up window will open.</li><li>Select and upload the desired file, then fill in the necessary details.</li><li>Click <strong>"Save"</strong> or <strong>"Add"</strong> to upload the document to the system.</li></ol><h3>How to Search for a Document:</h3><ol><li>Enter the document''s name or details in the appropriate search box.</li><li>The search results will be displayed in the document list.</li></ol><h3>How to Perform Actions on a Document:</h3><p><strong>Document Action Menu Overview</strong>:<br>The action menu offers users various options for managing and interacting with the assigned documents. Each action is designed to provide specific functionalities, allowing users to work efficiently with their documents.</p><h4>Available Options:</h4><ul><li><strong>Edit</strong>: Allows users to modify the document''s details, such as its name, description, or meta tags.<ul><li>After making changes, users can save the updates.</li></ul></li><li><strong>Share</strong>: Provides the option to share the document with other users or roles in the system.<ul><li>Users can set specific permissions, such as view or edit, for those with whom the document is shared.</li></ul></li><li><strong>View</strong>: Opens the document in a new window or an embedded viewer, allowing users to view the document''s content without downloading it.</li><li><strong>Upload a Version</strong>: Allows users to upload an updated version of the document.<ul><li>The original document remains in the system, and the new version is added as an update.</li></ul></li><li><strong>Version History</strong>: Displays all previous versions of the document.<ul><li>Users can view, or download any of the previous versions if the administrator allows the user to download document permission.</li></ul></li><li><strong>Comment</strong>: Allows users to add comments to the document.<ul><li>Other users can view and respond to comments, facilitating discussion and collaboration on the document.</li></ul></li><li><strong>Add Reminder</strong>: Sets a reminder for an event or action related to the document.<ul><li>Users can receive notifications or emails when the reminder date approaches.</li></ul></li></ul>', CAST(N'2023-06-02T17:32:19.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-10-05T06:58:47.4846831' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'5d858491-f9db-4aef-959f-5af9d7f3b7bd', N'MANAGE_ROLE', N'Manage Role', N'<ul><li>Allows administrators or users with appropriate permissions to create a new role in the system.</li><li>Opens a form or a pop-up window where permissions and role details can be defined.</li><li>Enter the role name and select the appropriate permissions from the available list.</li><li>Click <strong>"Save"</strong> or <strong>"Add"</strong> to add the role to the system with the specified permissions.</li></ul><p>&nbsp;</p><p><br>&nbsp;</p>', CAST(N'2023-06-03T05:20:37.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-10-04T14:25:11.9869322' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'ec6b2368-b8fd-4101-addf-5dec7c1d1c63', N'SHAREABLE_LINK', N'Shareable Link', N'<ul><li><strong>Shareable Link</strong>:<br>This feature allows users to share documents with anonymous users through a customizable link. Users have the flexibility to configure various options when creating a shareable link, including:<ul><li><strong>Start and Expiry Dates</strong>: Specify the validity period for the link, defining when it becomes active and when it expires.</li><li><strong>Password Protection</strong>: Optionally set a password to restrict access to the shared document.</li><li><strong>Download Permission</strong>: Choose whether recipients are allowed to download the document.</li></ul></li></ul><p>All options are optional, allowing users to customize the shareable link according to their preferences and requirements.</p>', CAST(N'2023-06-03T05:22:43.7270890' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-10-05T09:52:30.0027792' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'2dd28c72-3ed4-4f75-b23b-63cadcaa3982', N'ALL_DOCUMENTS', N'All Documents', N'<p>The <strong>"All Documents"</strong> page provides a complete overview of all documents uploaded in the DMS. It is the ideal place to search, view, manage, and distribute all available documents in the system.</p><p><strong>Main Components:</strong></p><ul><li><strong>"Add Document" Button:</strong> Allows any user with appropriate permissions to upload a new document into the system.<ul><li>Opens a form or a pop-up window where files can be selected and uploaded.</li></ul></li><li><strong>Search Box (by name):</strong> Allows users to search for a specific document by entering its name or other details.</li><li><strong>Search Box (by meta tags):</strong> Users can enter Meta tags to filter and search for specific documents.</li><li><strong>Category Dropdown:</strong> A dropdown menu that allows users to filter documents by category.</li><li><strong>Status Dropdown:</strong> &nbsp;There is an option users to store A dropdown menu that allows users to filter documents by Status.</li><li><strong>Storage Dropdown: </strong>The application lets users store documents in various storage options, such as AWS S3, Cloudflare R2, and local storage. Users can easily search for documents by selecting the desired storage option from a dropdown menu.</li><li><strong>Search Box (by creation date):</strong> Allows users to search for documents based on their creation date.</li><li><strong>List of All Uploaded Files:</strong> Displays all documents available in the system.<ul><li>Each entry includes document details such as name, creation date, category, status and storage.</li></ul></li><li><strong>Document Actions Menu:</strong> Alongside each document in the list, users will find an actions menu allowing them to perform various operations on the document:<ul><li><strong>Edit:</strong> Modify the document details, such as its name or description.</li><li><strong>Share:</strong> Share the document with other users or roles within the system.</li><li><strong>Get Shareable Link:</strong> Users can generate a shareable link to allow anonymous users to access documents. They can also protect the link with a password and set an expiration period, ensuring the link remains active only for the selected duration. Additionally, the link includes an option for recipients to download the shared document.</li><li><strong>View:</strong> Open the document for viewing.</li><li><strong>Upload a New Version:</strong> Add a new version of the document.</li><li><strong>Version History:</strong> Users can view all previous versions of a document, with the ability to restore any earlier version as needed. Each version can also be downloaded for offline access or review.</li><li><strong>Comment:</strong> Add or view comments on the document.</li><li><strong>Add Reminder:</strong> Set a reminder for the document.</li><li><strong>Send as Email:</strong> Send the document as an attachment via email.</li><li><strong>Delete:</strong> Remove the document from the system.</li></ul></li></ul><p><strong>Document Sharing:</strong></p><p>Users can select one, multiple, or all documents from the list and use the sharing option to distribute the selected documents to other users. This feature facilitates the mass distribution of documents to specific users or groups.</p>', CAST(N'2023-06-03T05:12:00.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-10-05T06:52:17.9880511' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'fac3d38a-5267-4b09-aea2-6682256ba777', N'ERROR_LOGS', N'Error Logs', N'<h4>Overview</h4><p>The <strong>ERROR_LOGS</strong> feature allows users to view the application logs generated by the backend REST API. This functionality is essential for monitoring application performance, diagnosing issues, and troubleshooting errors that may arise during API interactions.</p><h4>Features</h4><ol><li><strong>Accessing Error Logs</strong><ul><li><strong>Navigation:</strong><ul><li>Users can access the <strong>ERROR_LOGS</strong> section through the application’s administration panel or settings menu.</li></ul></li><li><strong>User Permissions:</strong><ul><li>Access to error logs may be restricted to users with specific roles, such as administrators or support staff, to maintain security and data integrity.</li></ul></li></ul></li><li><strong>Viewing Logs</strong><ul><li><strong>Log List:</strong><ul><li>The error logs are displayed in a list format, showing relevant details for each entry, including:<ul><li><strong>Timestamp:</strong> The date and time when the error occurred.</li><li><strong>Error Code:</strong> A unique code associated with the error.</li><li><strong>Error Message:</strong> A brief description of the error.</li><li><strong>Endpoint:</strong> The API endpoint that triggered the error.</li><li><strong>Request Data:</strong> The payload or parameters sent with the request (if applicable).</li><li><strong>Response Data:</strong> The response returned from the server (if applicable).</li></ul></li></ul></li><li><strong>Pagination:</strong><ul><li>Logs can be paginated to avoid overwhelming users with too much information at once, allowing users to navigate through entries easily.</li></ul></li></ul></li><li><strong>Filtering and Searching</strong><ul><li><strong>Filter Options:</strong><ul><li>Users can filter logs by various criteria, such as date range, error code, or specific endpoints, to quickly locate relevant entries.</li></ul></li><li><strong>Search Functionality:</strong><ul><li>A search bar allows users to enter keywords or phrases to find specific logs, improving the efficiency of troubleshooting.</li></ul></li></ul></li><li><strong>Log Details</strong><ul><li><strong>Expand/Collapse Feature:</strong><ul><li>Users can click on a log entry to expand and view additional details, such as:<ul><li>Full error stack trace (if available).</li><li>Contextual information regarding the request and server response.</li></ul></li></ul></li><li><strong>Export Option:</strong><ul><li>Users can export the logs in various formats (e.g., CSV, JSON) for offline analysis or reporting purposes.</li></ul></li></ul></li><li><strong>User Interaction Flow</strong><ul><li><strong>Navigating to Error Logs:</strong><ul><li>Users select the <strong>ERROR_LOGS</strong> option from the administration panel to access the log list.</li></ul></li><li><strong>Viewing and Filtering Logs:</strong><ul><li>Users can apply filters and search for specific logs to identify issues effectively.</li></ul></li><li><strong>Exploring Log Details:</strong><ul><li>Users can expand log entries to review detailed error information and troubleshoot accordingly.</li></ul></li></ul></li></ol><h3>Summary</h3><p>The <strong>ERROR_LOGS</strong> functionality provides a robust interface for users to view and manage application logs related to the backend REST API. With features such as filtering, searching, and detailed log views, users can effectively monitor application performance, diagnose errors, and troubleshoot issues, ensuring a smoother user experience and improved application reliability.</p>', CAST(N'2023-06-03T05:22:43.7270890' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-10-05T09:14:40.3391298' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'd6e392a9-b180-4c68-8566-6f289150a226', N'ADD_DOCUMENT', N'Manage document', N'<ul><li><strong>Allows users to upload and add a new document to the system.</strong></li><li>It includes the following fields:</li><li><strong>Upload Document:</strong> An option to upload the document file.</li><li><strong>Category:</strong> The category under which the document is classified.</li><li><strong>Name:</strong> The name of the document.</li><li><strong>Status:</strong> The status of the document (e.g., confidential or public).</li><li><strong>Description:</strong> A detailed description or additional notes related to the document.</li><li><strong>Meta Tags:</strong> Tags or keywords associated with the document for easier searching.</li></ul>', CAST(N'2023-06-02T17:33:42.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-10-05T09:19:10.4910558' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'b99e45c1-9d9f-4b0e-80f0-906c7c830394', N'STORAGE_SETTINGS', N'Storage Settings', N'<p><strong>Document Storage Settings</strong>:<br>Users can configure various storage options, including AWS S3 and Cloudflare R2, with specific fields required for each storage type. Additionally, there is a default option available for storing files on a local server. This local server setting cannot be deleted, ensuring a reliable and consistent storage option for users.</p><ol><li><strong>Enable Encryption</strong>: When selected, this option ensures that files are stored in encrypted form within the chosen storage.</li><li><strong>Set as Default</strong>: If this option is set to "true," the storage becomes the default selection in the dropdown on the document add page.</li></ol><p>Upon saving the storage settings, the system attempts to upload a dummy file to verify the configuration. If the upload is successful, the settings are saved; otherwise, an error message prompts the user to adjust the field values.</p><ul><li><h4><strong>Add a new Storage Setting to the system.</strong></h4></li><li><strong>It includes the following fields:</strong></li><li><strong>Storage Type: </strong>AWS/CloudFlare-R2</li><li><strong>Access Key:</strong></li><li><strong>Secret Key:</strong></li><li><strong>Bucket Name:</strong></li><li><strong>Account ID: </strong>Required for CloudFlare-R2 Storage Type</li><li><strong>Enable Encryption: </strong>When selected, this option ensures that files are stored in encrypted form within the chosen storage.</li><li><strong>Is Default:</strong> &nbsp;If this option is set to "true," the storage becomes the default selection in the dropdown on the document add page.</li><li>&nbsp;</li><li><h4><strong>Edit Storage Setting to the system.</strong></h4></li><li>Users can edit existing storage settings from the storage settings list, which includes an edit button on the left side of each row. When the edit button is clicked, the row opens in edit mode, allowing users to modify the following fields: name, "Is Default," and "Enable Encryption." This provides users with the flexibility to update their storage configurations as needed.</li></ul><h4>CREATE AWS S3 ACCOUNT:</h4><p><a href="https://aws.amazon.com/free/?gclid=CjwKCAjwx4O4BhAnEiwA42SbVPBXf7hpN07vHx4ObiZX3xFHpgCLP9mHQ4P1CaykaQkJKT53F2EQFhoCWRkQAvD_BwE&amp;trk=b8b87cd7-09b8-4229-a529-91943319b8f5&amp;sc_channel=ps&amp;ef_id=CjwKCAjwx4O4BhAnEiwA42SbVPBXf7hpN07vHx4ObiZX3xFHpgCLP9mHQ4P1CaykaQkJKT53F2EQFhoCWRkQAvD_BwE:G:s&amp;s_kwcid=AL!4422!3!536324516040!e!!g!!aws%20s3%20account!11539706604!115473954714&amp;all-free-tier.sort-by=item.additionalFields.SortRank&amp;all-free-tier.sort-order=asc&amp;awsf.Free%20Tier%20Types=*all&amp;awsf.Free%20Tier%20Categories=*all">https://aws.amazon.com/free/?gclid=CjwKCAjwx4O4BhAnEiwA42SbVPBXf7hpN07vHx4ObiZX3xFHpgCLP9mHQ4P1CaykaQkJKT53F2EQFhoCWRkQAvD_BwE&amp;trk=b8b87cd7-09b8-4229-a529-91943319b8f5&amp;sc_channel=ps&amp;ef_id=CjwKCAjwx4O4BhAnEiwA42SbVPBXf7hpN07vHx4ObiZX3xFHpgCLP9mHQ4P1CaykaQkJKT53F2EQFhoCWRkQAvD_BwE:G:s&amp;s_kwcid=AL!4422!3!536324516040!e!!g!!aws%20s3%20account!11539706604!115473954714&amp;all-free-tier.sort-by=item.additionalFields.SortRank&amp;all-free-tier.sort-order=asc&amp;awsf.Free%20Tier%20Types=*all&amp;awsf.Free%20Tier%20Categories=*all</a></p><h4><strong>CREATE &nbsp;Cloudflare R2</strong></h4><p><a href="https://developers.cloudflare.com/workers/tutorials/upload-assets-with-r2/">https://developers.cloudflare.com/workers/tutorials/upload-assets-with-r2/</a></p><ul><li>&nbsp;</li></ul>', CAST(N'2023-06-03T05:22:44.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-10-05T08:46:32.2587433' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'd96ee5aa-4253-4a28-ba61-94b15b6cbfae', N'VERSION_HISTORY', N'Document versions', N'<p><strong>Uploading a New Version of the Document:</strong></p><p>Allows users to upload an updated or modified version of an existing document.</p><p>It includes the following fields:</p><ul><li><strong>Upload a New Version:</strong> A dedicated section for uploading a new version of the document.</li><li><strong>Restore previous version document to current version : </strong>When a user restores a previous version as the current document, the existing current document is automatically added to the document history. The restored document then becomes the active current document, ensuring effective version control and easy tracking of changes</li><li><strong>Upload Document:</strong> An option to upload the document file. Users can select the file they want to upload, and the text "No file chosen" will appear until a file is selected.</li><li><strong>View Document</strong>:<br>This feature provides users with the ability to preview previous versions of a document. Users can easily access and review any earlier version, allowing for better assessment and comparison before deciding to restore or make further edits.</li></ul><p><strong>How to Upload a New Version of the Document:</strong></p><ol><li>Navigate to the "All Documents" page.</li><li>Select the document for which you want to upload a new version.</li><li>Click on the "Upload a New Version" option or a similar button.</li><li>A dedicated form will open where you can select and upload the appropriate file.</li><li>After uploading the file, click "Save" or "Add" to update the document in the system with the new version.</li></ol>', CAST(N'2023-06-03T05:11:05.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-10-05T10:01:08.4565463' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'0fae65e2-091d-469b-8a2a-9bb363ba8290', N'DOCUMENTS_AUDIT_TRAIL', N'Document audit history', N'<p><strong>General Description:</strong></p><p>The "Document Audit History" page provides a detailed view of all actions performed on documents within the DMS. It allows administrators and users with appropriate permissions to monitor and review document-related activities, ensuring transparency and information security.</p><p><strong>Main Components:</strong></p><p><strong>Search Boxes:</strong></p><ul><li><strong>By Document Name:</strong> Allows users to search for a specific document by entering its name or other details.</li><li><strong>By Meta Tag:</strong> Users can enter meta tags to filter and search for specific document-related activities.</li><li><strong>By User:</strong> Enables filtering activities based on the user who performed the operation.</li></ul><p><strong>List of Audited Documents:</strong></p><p>Displays all actions taken on documents in a tabular format.</p><p>Each entry includes details of the action, such as the date, document name, category, operation performed, who performed the operation, to which user, and to which role the operation was directed.</p><p>Users can click on an entry to view additional details or access the associated document.</p><p><strong>List Sorting:</strong></p><p>Users can sort the list by any of the available columns, such as "Date," "Name," "Category Name," "Operation," "Performed by," "Directed to User," and "Directed to Role."</p><p>This feature makes it easier to organize and analyze information based on specific criteria.</p><p><strong>How to Search the Audit History:</strong></p><ul><li>Enter your search criteria in the corresponding search box (document name, meta tag, or user).</li><li>The search results will be displayed in the audited documents list.</li></ul><p><strong>How to Sort the List:</strong></p><ul><li>Click on the column title by which you want to sort the list (e.g., "Date" or "Name").</li><li>The list will automatically reorder based on the selected criterion.</li></ul>', CAST(N'2023-06-03T05:17:16.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-10-05T05:50:15.8413357' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'b1c70caf-ce26-4dff-8f8a-aed4c8eab097', N'PAGE_HELPERS', N'Page Helpers', N'<p>Users can manage the pages within the application using a user-friendly interface that displays a list of available pages. Each entry in the list includes options to <strong>Edit</strong> or <strong>View</strong> the corresponding page''s details.</p><h4>Features</h4><ol><li><h4><strong>List of Pages</strong></h4><ul><li>Users can see a comprehensive list of all pages in the application, each with the following details:<ul><li><strong>Unique Code:</strong> A non-editable code for each page.</li><li><strong>Editable Name:</strong> An editable field that allows users to change the page name.</li><li><strong>Page Info Content:</strong> A section that displays the functionality description of each page.</li><li>&nbsp;</li></ul></li></ul></li><li><h4><strong>Edit Feature</strong></h4><ul><li><strong>Edit Button:</strong><ul><li>When a user clicks the <strong>Edit</strong> button next to a page, they are directed to an editable form.</li><li>Users can modify the page name and update the page info content to reflect any changes or improvements.</li><li><strong>Validation:</strong><ul><li>The form includes validation checks to ensure that the new name is unique and meets any defined requirements (e.g., length, special characters).</li></ul></li><li><strong>Save Changes:</strong><ul><li>Users can save the changes, which are then reflected in the list of pages and will persist across sessions.</li><li>&nbsp;</li></ul></li></ul></li></ul></li><li><h4><strong>View Feature</strong></h4><ul><li><strong>View Button:</strong><ul><li>Clicking the <strong>View</strong> button opens a dialog box displaying a preview of the page info content.</li><li>This preview includes &nbsp;current page name, and detailed functionality description.</li><li><strong>Modal Dialog:</strong><ul><li>The dialog box is modal, meaning users cannot interact with the rest of the application until they close the dialog.</li><li>Users can close the dialog by clicking an "X" button or a "Close" button.</li></ul></li></ul></li></ul></li><li>&nbsp;<ul><li><h4><strong>Navigating to the Page List:</strong></h4><ul><li>Users can easily navigate to the page list through the main navigation menu.</li></ul></li><li><strong>Editing a Page:</strong><ul><li>Users select the <strong>Edit</strong> button next to the desired page, modify the name and content, and click <strong>Save</strong> to apply the changes.</li></ul></li><li><strong>Viewing a Page:</strong><ul><li>Users can click the <strong>View</strong> button to open the dialog box, review the details, and close the dialog when finished.</li></ul></li></ul></li></ol><h3>Summary</h3><p>This functionality empowers users to effectively manage page names and content within the application, ensuring that information is accurate and up-to-date. The combination of edit and view features enhances the user experience by allowing for quick modifications and easy access to page details.</p>', CAST(N'2023-06-03T05:22:43.7270890' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-10-05T08:53:15.1785445' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'd0e88580-71d2-4d74-b1ac-b9f34aec6818', N'DOCUMENT_CATEGORIES', N'Document categories', N'<p><strong>The "Document Categories" page serves as a centralized hub for managing and organizing categories, which essentially represent the departments that work with the files. It offers a hierarchical structure, allowing the creation of main categories and subcategories.</strong></p><h4><strong>Main Components:</strong></h4><p><strong>"Add New Document Category" Button:</strong></p><ul><li>Allows administrators or users with appropriate permissions to create a new category or department.</li><li>Opens a form or a pop-up window where details like the category name and description can be entered.</li></ul><p><strong>List of Existing Categories:</strong></p><ul><li>Displays all the categories or departments created within the system.</li><li>Each entry includes the category name and associated action options.</li></ul><p><strong>Action Menu for Each Category:</strong></p><ul><li>Next to each category, users will find action options that allow them to manage the category:<ul><li><strong>Edit:</strong> Enables modification of the category''s details, such as the name or description.</li><li><strong>Delete:</strong> Removes the category from the system. This action may require confirmation to prevent accidental deletions.</li></ul></li></ul><p><strong>Double Arrow Button "&gt;&gt;":</strong></p><ul><li>Located next to each main category.</li><li>When clicked, it reveals the subcategories associated with the main category.</li><li>Allows users to view and manage subcategories in a hierarchical manner.</li></ul><h4><strong>How to Add a New Category:</strong></h4><ol><li>Click on the "Add New Document Category" button.</li><li>A form or pop-up window will open.</li><li>Enter the category name and description.</li><li>Click "Save" or "Add" to add the category to the system.</li></ol><h4><strong>How to View Subcategories:</strong></h4><ol><li>Locate the main category in the list.</li><li>Click on the double arrow button "&gt;&gt;" next to the category name.</li><li>The associated subcategories will be displayed beneath the main category.</li></ol>', CAST(N'2023-06-03T05:16:36.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-10-05T07:06:36.4241448' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'd8506639-f4ec-42d8-9939-bae893abef57', N'ROLES', N'Roles', N'<p><strong>The "User Roles" page is essential for managing and defining permissions within the CMR DMS. Roles represent predefined sets of permissions that can be assigned to users, ensuring that each user has access only to the functionalities and documents appropriate to their position and responsibilities within the organization.</strong></p><h3><strong>Main Components:</strong></h3><p><strong>"Add Roles" Button:</strong></p><ul><li>Allows administrators or users with appropriate permissions to create a new role in the system.</li><li>Opens a form or pop-up window where the role’s permissions and details can be defined.</li></ul><p><strong>List of Existing Roles:</strong></p><ul><li>Displays all roles created within the system in a tabular format.</li><li>Each entry includes the role name and associated action options.</li></ul><p><strong>Action Menu for Each Role:</strong></p><ul><li>Includes options for "Edit" and "Delete."<ul><li><strong>Edit:</strong> Allows modification of the role''s details and permissions.</li><li><strong>Delete:</strong> Removes the role from the system. This action may require confirmation to prevent accidental deletions.</li></ul></li></ul><p><strong>Role Creation Page:</strong></p><ul><li>Here, administrators can define specific permissions for each role.</li><li>Permissions can include rights such as viewing, editing, deleting, or sharing documents, managing users, defining categories, and more.</li><li>Once permissions are set, they can be saved to create a new role or update an existing one.</li></ul><h3><strong>How to Add a New Role:</strong></h3><ol><li>Click on the "Add Roles" button.</li><li>A form or pop-up window will open.</li><li>Enter the role name and select the appropriate permissions from the available list.</li><li>Click "Save" or "Add" to add the role to the system with the specified permissions.</li></ol>', CAST(N'2023-06-03T05:18:29.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-10-05T05:52:38.0563727' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'ee4f69f1-1ed7-4447-87d4-c43a0b0f92e0', N'UPLOAD_NEW_VERSION', N'Upload version file', N'<p><strong>How to Upload a New Version of a Document:</strong></p><ol><li>Navigate to the "All Documents" page.</li><li>Select the document for which you want to upload a new version.</li><li>Click on the option "Upload a New Version" or a similar button.</li><li>A dedicated form will open, allowing you to select and upload the appropriate file.</li><li>After uploading the file, click "Save" or "Add" to update the document in the system with the new version.</li></ol>', CAST(N'2023-06-03T05:14:00.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-10-05T06:15:02.9239849' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'25ccccd4-bd60-4f8b-8bc1-c49eca98fb49', N'EMAIL_SMTP_SETTINGS', N'SMTP Email Settings', N'<p>The <strong>"Email SMTP Settings"</strong> page within CMR DMS allows administrators to configure and manage the SMTP settings for sending emails. This ensures that emails sent from the system are correctly and efficiently delivered to recipients.</p><p><strong>Key Components:</strong></p><ul><li><p><strong>SMTP Settings Table:</strong> Displays all configured SMTP settings in a tabular format.</p><p>Each entry in the table includes details such as the username, host, port, and whether that configuration is set as the default.</p></li><li><p><strong>"Add Settings" Button:</strong> Allows administrators to add a new SMTP configuration.</p><p>Clicking the button opens a form where details like username, host, port, and the option to set it as the default configuration can be entered.</p></li></ul><p><strong>"Add Settings" Form:</strong></p><p>This form opens when administrators click the "Add Settings" button and includes the following fields:</p><ul><li><strong>Username:</strong> The username required for authentication on the SMTP server.</li><li><strong>Host:</strong> The SMTP server address.</li><li><strong>Port:</strong> The port on which the SMTP server listens.</li><li><strong>Is Default:</strong> A checkbox that allows setting this configuration as the default for sending emails.</li></ul><p><strong>How to Add a New SMTP Configuration:</strong></p><ol><li>Click the "Add Settings" button.</li><li>The "Add Settings" form will open, where you can enter the SMTP configuration details.</li><li>Fill in the necessary fields and select the desired options.</li><li>After completing the details, click "Save" or "Add" to add the configuration to the system.</li></ol>', CAST(N'2023-06-03T05:25:45.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-10-04T14:30:24.7343669' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'3e0fe36d-cde5-4bd9-b65d-cfaeadcffce3', N'COMPANY_PROFILE', N'Company Profile', N'<p>Here’s a detailed description of the functionality for managing the company profile, focusing on the company name, logo, and banner logo on the login screen.</p><h3>&nbsp;</h3><h4>Overview</h4><p>The Company Profile feature allows users to customize the branding of the application by entering the company name and uploading logos. This customization will reflect on the login screen, enhancing the professional appearance and brand identity of the application.</p><h4>Features</h4><ol><li><h4><strong>Company Name</strong></h4><ul><li><strong>Input Field:</strong><ul><li>Users can enter the name of the company in a text input field.</li><li><strong>Validation:</strong><ul><li>The field will have validation to ensure the name is not empty and meets any specified length requirements (e.g., minimum 2 characters, maximum 50 characters).</li><li><strong>Browser Title Setting:</strong></li><li>Upon saving the company name, the application will dynamically set the browser title to match the company name, improving brand visibility in browser tabs.</li></ul></li></ul></li></ul></li><li><h4><strong>Logo Upload</strong></h4><ul><li><strong>Upload Button:</strong><ul><li>Users can upload a company logo that will be displayed in the header of the login page.</li><li><strong>File Requirements:</strong><ul><li>Supported file formats: PNG, JPG, JPEG (with size limits, e.g., up to 2 MB).</li><li>Recommended dimensions for optimal display (e.g., width: 200px, height: 100px).</li></ul></li></ul></li><li><strong>Preview:</strong><ul><li>After uploading, a preview of the logo will be displayed to confirm the upload.</li></ul></li></ul></li><li><h4><strong>Banner Logo Upload</strong></h4><ul><li><strong>Upload Button:</strong><ul><li>Users can upload a banner logo that will appear prominently on the login screen.</li><li><strong>File Requirements:</strong><ul><li>Supported file formats: PNG, JPG, JPEG (with size limits, e.g., up to 3 MB).</li><li>Recommended dimensions for optimal display (e.g., width: 1200px, height: 300px).</li></ul></li></ul></li><li><strong>Preview:</strong><ul><li>A preview of the banner logo will be displayed after the upload for confirmation.</li></ul></li></ul></li><li><h4><strong>User Interaction Flow</strong></h4><ul><li><h4><strong>Navigating to the Company Profile:</strong></h4><ul><li>Users can access the company profile settings from the application’s settings menu or administration panel.</li></ul></li><li><strong>Editing Company Profile:</strong><ul><li>Users enter the company name, upload the logo, and the banner logo.</li><li>A "Save Changes" button will be available to apply the modifications.</li></ul></li><li><strong>Saving Changes:</strong><ul><li>Upon clicking "Save Changes," the uploaded logos and company name will be saved and reflected on the login screen.</li><li>Confirmation messages will be displayed to indicate successful updates.</li></ul></li></ul></li><li><strong>Display on Login Screen</strong><ul><li><strong>Header Display:</strong><ul><li>The company logo will be displayed in the header at the top of the login page, maintaining a consistent branding experience.</li></ul></li><li><strong>Banner Display:</strong><ul><li>The banner logo will be displayed prominently below the header, enhancing the visual appeal of the login interface.</li></ul></li></ul></li></ol><h3>Summary</h3><p>The Company Profile functionality allows for a customizable branding experience, enabling users to set their company name and logos that will be visible on the login screen. This feature enhances user engagement and presents a professional image right from the login phase of the application.</p>', CAST(N'2023-06-03T05:22:43.7270890' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-10-05T08:59:50.4836430' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'762a5894-0c49-48d8-9e0c-e5062a4c3322', N'SEND_EMAIL', N'Send mail', N'<ul><li><strong>How to Send a Document as an Email Attachment:</strong></li><li><strong>Select the email field</strong>: Navigate to the section where you can compose an email and select the field for entering the recipient''s email address.</li><li><strong>Enter the email address</strong>: Type the recipient''s email address in the provided field.</li><li><strong>Subject field</strong>: Enter a relevant subject for your email.</li><li><strong>Email content</strong>: Write the body of your email, providing any necessary context or information.</li><li><strong>Attach the document</strong>: Find the option to "Attach" or "Upload" a document, then select the file you wish to send.</li><li><strong>Send the email</strong>: After attaching the document and ensuring the recipient, subject, and content are correct, click the "Send" button to deliver the email with the attached document.</li></ul>', CAST(N'2023-06-03T05:16:00.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-10-05T06:16:51.7893891' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'dd0c9840-b7c6-4a51-b78a-e674918ff7e5', N'NOTIFICATIONS', N'Notifications', N'<ul><li><strong>Document Shared Notification</strong>:<ul><li>Sends real-time notifications to users when a document is shared with them.</li><li>Notifications are sent via email and in-app, with details about the shared document, including name, category, and shared user.</li><li>For documents shared with external users, the recipient is notified with a secure link to access the document.</li></ul></li><li><strong>Reminder Notifications</strong>:<ul><li>Sends reminders to users for upcoming deadlines or actions related to documents (e.g., review deadlines or document expiration).</li><li>Users can configure reminder frequency and set specific reminders for important documents.</li><li>Reminders are delivered via both email and in-app notifications.</li></ul></li></ul><p>&nbsp;</p>', CAST(N'2023-06-03T05:28:05.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2023-08-25T19:10:29.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'509dfdb8-8e5c-4370-8427-f6a9c2c78007', N'ROLE_USER', N'Role users', N'<p><strong>The "User with Role" page is dedicated to assigning specific roles to users within the DMS. It allows administrators to associate users with particular roles using an intuitive "drag and drop" system. Users can be moved from the general user list to the "Users with Role" list, thereby assigning them the selected role.</strong></p><h3><strong>Main Components:</strong></h3><ul><li><strong>Title "User with Role":</strong> Indicates the purpose and functionality of the page.</li><li><strong>Department:</strong> Displays the currently selected department, in this case, "Approvals."<ul><li>There may be an option to change the department if needed.</li></ul></li><li><strong>Select Role:</strong> A dropdown menu or selection box where administrators can choose the role they wish to assign to users.<ul><li>Once a role is selected, users can be moved into the "Users with Role" list to assign them that role.</li></ul></li><li><strong>Note:</strong> A short instruction explaining how to use the page, indicating that users can be moved from the "All Users" list to the "Users with Role" list to assign them a role.</li><li><strong>"All Users" and "Users with Role" Lists:</strong><ul><li><strong>"All Users":</strong> Displays a complete list of all registered users in the CMR DMS.</li><li><strong>"Users with Role":</strong> Displays the users who have been assigned the selected role.</li><li>Users can be moved between these lists using the "drag and drop" functionality.</li></ul></li></ul><h3><strong>How to Assign a Role to a User:</strong></h3><ol><li>Select the desired role from the "Select Role" box.</li><li>Locate the desired user in the "All Users" list.</li><li>Using the mouse or a touch device, drag the user from the "All Users" list and drop them into the "Users with Role" list.</li><li>The selected user will now be associated with the chosen role and will appear in the "Users with Role" list.</li></ol>', CAST(N'2023-06-03T05:23:23.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-10-05T06:17:44.8519754' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'0cc83192-f05b-4c97-ab20-f7f3b5ba16d0', N'REMINDERS', N'Reminders', N'<p>The <strong>"Reminders"</strong> page is the central hub for managing reminders within CMR DMS, where users can create, view, and manage reminders or notifications related to documents or other activities. Reminders can be set to repeat at regular intervals and can be associated with a specific document for efficient tracking of tasks and activities.</p><h3>Main components:</h3><ol><li><strong>"Add Reminder" Button</strong>:<ul><li>Allows users to create a new reminder.</li><li>Upon clicking, it opens a form where details such as subject, message, frequency, associated document, and reminder date can be entered.</li></ul></li><li><strong>Reminders Table</strong>:<ul><li>Displays all created reminders in a tabular format.</li><li>Each entry includes:<ul><li>Start date</li><li>End date</li><li>Reminder subject</li><li>Associated message</li><li>Recurrence frequency</li><li>Associated document (if applicable)</li></ul></li></ul></li></ol><h3>"Add Reminder" Form:</h3><p>When users click on the <strong>"Add Reminder"</strong> button, a form opens with the following fields:</p><ul><li><strong>Subject</strong>: The title or topic of the reminder (e.g., "Document Review").</li><li><strong>Message</strong>: Additional details about the reminder (e.g., "Review the document by X date").</li><li><strong>Repeat Reminder</strong>: Sets the recurrence frequency, with options such as:<ul><li>Daily</li><li>Weekly</li><li>Monthly</li><li>Semi-annually</li></ul></li><li><strong>Send Email</strong>: An option to send an email notification when the reminder is activated.</li><li><strong>Select Users</strong>: Allows selecting users to whom the reminder will be sent. It can be customized for specific teams or individuals.</li><li><strong>Reminder Date</strong>: The date and time when the reminder will be activated and sent.</li></ul><h3>How to add a new reminder:</h3><ol><li>Navigate to the <strong>"Reminders"</strong> page.</li><li>Click the <strong>"Add Reminder"</strong> button.</li><li>Fill in the form fields with the necessary information.</li><li>After entering all the details, click <strong>"Save"</strong> or <strong>"Add"</strong> to save the reminder in the system.</li></ol><h3>"Add Reminder" Functionality in the "Manage Reminders" section:</h3><p>This is the dedicated place for creating and managing notifications related to events or tasks. The <strong>"Add Reminder"</strong> functionality offers full customization, and reminders can be sent to selected users.</p><ul><li><strong>Subject</strong>: Enter a descriptive title for the reminder.</li><li><strong>Message</strong>: Add a clear and concise message to detail the purpose of the reminder.</li><li><strong>Repeat Reminder</strong>: Set whether the reminder will be repeated periodically (daily, weekly, etc.).</li><li><strong>Send Email</strong>: If this option is checked, the reminder will also be sent as an email.</li><li><strong>Select Users</strong>: Select users from the system''s list to whom the reminder will be sent.</li><li><strong>Reminder Date</strong>: Set the date and time for the reminder to be triggered.</li></ul>', CAST(N'2023-06-02T17:31:21.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-10-05T04:41:27.0060525' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'a3664127-34f1-494c-84c5-fc3f307a9d11', N'USER_PAGE_PERMISSION_TO', N'User Page Permission To', N'<ul><li>Enable the ability to assign specific permissions to users that are not tied to their assigned roles. This gives admins the flexibility to grant access to particular features for individual users.</li><li>Click <strong>"Save"</strong> or <strong>"Add"</strong> to assign the user to the system with the specified permissions.</li></ul>', CAST(N'2023-06-03T05:22:44.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20241009055525_Version_V31_Data', N'8.0.13');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

ALTER TABLE [Documents] ADD [IsAddedPageIndxing] bit NOT NULL DEFAULT CAST(0 AS bit);
GO

CREATE TABLE [DocumentIndexes] (
    [Id] uniqueidentifier NOT NULL,
    [DocumentId] uniqueidentifier NOT NULL,
    [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
    CONSTRAINT [PK_DocumentIndexes] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_DocumentIndexes_Documents_DocumentId] FOREIGN KEY ([DocumentId]) REFERENCES [Documents] ([Id]) ON DELETE CASCADE
);
GO

CREATE INDEX [IX_DocumentIndexes_DocumentId] ON [DocumentIndexes] ([DocumentId]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20241022085643_Version_V4', N'8.0.13');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsDeleted], [OrderNo]) 
	VALUES (N'D6B63A2E-F7DB-4F83-B5DD-96A000D9A789', N'Deep Search', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', 0, 4)

--Operations
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsDeleted]) 
	VALUES (N'393B2BA9-0664-470D-807F-D5D936FAAF27', N'Deep Search', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsDeleted]) 
	VALUES (N'B1139F93-8ADC-4034-BCF1-B27203831FA8', N'Add Document Index', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsDeleted]) 
	VALUES (N'5B53E317-E2B4-4808-839F-424CF25762B5', N'Remove Document Index', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted])
    VALUES (N'a441d0f5-84cb-40b1-b1c3-c8c971e68f80', N'Add Signature', CAST(N'2021-12-22T16:19:27.0969638' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T16:19:27.0966667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)

--ScreenOperations
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'42794D41-EF8A-4F8E-B0AD-1FCEB50B3E2E', N'393B2BA9-0664-470D-807F-D5D936FAAF27', N'D6B63A2E-F7DB-4F83-B5DD-96A000D9A789', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'ECA884BB-CCB8-4723-A137-D73F988AE300', N'B1139F93-8ADC-4034-BCF1-B27203831FA8', N'D6B63A2E-F7DB-4F83-B5DD-96A000D9A789', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'A73CCEF3-DA47-49E8-9944-EBA0F18B2E40', N'5B53E317-E2B4-4808-839F-424CF25762B5', N'D6B63A2E-F7DB-4F83-B5DD-96A000D9A789', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted])
 VALUES (N'2e159fd9-df31-400f-9dde-88bdc34bf42f', N'a441d0f5-84cb-40b1-b1c3-c8c971e68f80', N'FC97DC8F-B4DA-46B1-A179-AB206D8B7EFD', CAST(N'2021-12-22T17:10:15.7372916' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2021-12-22T17:10:15.7400000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)

--RoleClaim
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) 
	VALUES (N'393B2BA9-0664-470D-807F-D5D936FAAF27', N'D6B63A2E-F7DB-4F83-B5DD-96A000D9A789', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Deep_Search_Deep_Search', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) 
	VALUES (N'B1139F93-8ADC-4034-BCF1-B27203831FA8', N'D6B63A2E-F7DB-4F83-B5DD-96A000D9A789', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Deep_Search_Add_Document_Index', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) 
	VALUES (N'5B53E317-E2B4-4808-839F-424CF25762B5', N'D6B63A2E-F7DB-4F83-B5DD-96A000D9A789', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Deep_Search_Remove_Document_Index', N'')

INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'A8209505-ED74-4D3A-93F4-8185192994DC', N'DEEP_SEARCH', N'Deep Search', N'<p>The <strong>Deep Search</strong> feature allows you to search through the content of various types of documents, including Word documents, PDFs, Notepad files, PPT, Images (.tif, .tiff, .png, .jpg, .jpeg, .bmp, .pbm, .pgm, .ppm) and Excel spreadsheets. Follow the instructions below to ensure accurate and efficient searches.</p><h4><strong>1. How to Perform a Search</strong></h4><ul><li><strong>Basic Search</strong>: Enter keywords or phrases in the search bar. The system will look for these terms across supported document types. When the ''Search Exact Match'' checkbox is checked, the system will search for documents that contain the exact phrase entered in the search field.&nbsp;</li></ul><h4><strong>2. Case Sensitivity</strong></h4><ul><li><strong>Case-Insensitive Search</strong>: The search is not case-sensitive. This means that searching for "Report" and "Report" will return the same results, regardless of capitalization.</li></ul><h4><strong>3. Common Words</strong></h4><ul><li><strong>Ignored Words</strong>: Common words such as "and," "the," and "is" are automatically ignored to provide more relevant results. This improves search accuracy by focusing on significant terms in your query.</li></ul><h4><strong>4. Word Variations (Stemming)</strong></h4><ul><li><strong>Word Variations</strong>: The search automatically includes variations of the words you enter. For example, if you search for "run", the system will also return documents that contain "running", "runs", and similar variations.</li></ul><h4><strong>5. Supported File Types</strong></h4><p>Deep Search can find content within the following document types:</p><ul><li><strong>Microsoft Word</strong> documents (.doc, .docx)</li><li><strong>Writable PDF</strong> files (editable, non-scanned PDFs)</li><li><strong>Notepad</strong> text files (.txt)</li><li><strong>Excel spreadsheets</strong> (.xls, .xlsx)</li><li><strong>PowerPoint documents</strong> (.ppt, .pptx)</li><li><strong>Images </strong>(tif,.tiff,.png,.jpg,.jpeg,.bmp,.pbm,.pgm,.ppm)</li></ul><p>Ensure that your documents are in one of these supported formats for the search function to work properly.</p><h4><strong>6. Search Results Limit</strong></h4><ul><li>You will receive a <strong>maximum of 10 results</strong> per search. If more documents match your query, you may need to refine your search to narrow down the results.</li></ul><h4><strong>7. Indexing Time for New Documents</strong></h4><ul><li>After uploading a new document, it may take <strong>15 to 20 minutes</strong> for it to become searchable. This delay is due to background document indexing, which is necessary to prepare the document''s content for Deep Search.</li><li>&nbsp;</li><li><h4><strong>8. Removing a Document from Indexing</strong></h4></li><li>If you no longer want a document to be searchable, you can <strong>remove it from indexing</strong>. Follow these steps:</li><li>Navigate to the <strong>Document List</strong> page.</li><li>Find the document you want to remove from search indexing.</li><li>Click on the <strong>Remove Page Indexing</strong> menu item for that document.</li><li>After removal, the document''s content will no longer be searchable. <strong>Once removed, the document will not appear in search results, and the indexing process cannot be reversed.</strong></li></ul><h4><strong>9. Tips for Better Search Results</strong></h4><ul><li>Use <strong>specific keywords</strong>: The more specific your search terms, the more relevant the results will be.</li><li>Combine <strong>exact phrase search</strong> and regular search terms to narrow down results (e.g., "annual report" budget overview).</li><li>Avoid using common words that the system ignores unless they are part of an exact phrase search.</li></ul>', CAST(N'2023-06-03T05:22:44.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20241022085703_Version_V4_Data', N'8.0.13');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

ALTER TABLE [DocumentVersions] DROP CONSTRAINT [FK_DocumentVersions_Users_CreatedBy];
GO

DECLARE @var19 sysname;
SELECT @var19 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[EmailSMTPSettings]') AND [c].[name] = N'IsEnableSSL');
IF @var19 IS NOT NULL EXEC(N'ALTER TABLE [EmailSMTPSettings] DROP CONSTRAINT [' + @var19 + '];');
ALTER TABLE [EmailSMTPSettings] DROP COLUMN [IsEnableSSL];
GO

ALTER TABLE [UserNotifications] ADD [FileRequestDocumentId] uniqueidentifier NULL;
GO

ALTER TABLE [UserNotifications] ADD [WorkflowInstanceId] uniqueidentifier NULL;
GO

ALTER TABLE [EmailSMTPSettings] ADD [EncryptionType] nvarchar(max) NULL;
GO

ALTER TABLE [EmailSMTPSettings] ADD [FromEmail] nvarchar(max) NULL;
GO

ALTER TABLE [EmailSMTPSettings] ADD [FromName] nvarchar(max) NULL;
GO

ALTER TABLE [DocumentVersions] ADD [Comment] nvarchar(max) NULL;
GO

ALTER TABLE [DocumentVersions] ADD [SignById] uniqueidentifier NULL;
GO

ALTER TABLE [DocumentVersions] ADD [SignDate] datetime2 NULL;
GO

ALTER TABLE [Documents] ADD [ClientId] uniqueidentifier NULL;
GO

ALTER TABLE [Documents] ADD [Comment] nvarchar(max) NULL;
GO

ALTER TABLE [Documents] ADD [DocumentNumber] int NOT NULL IDENTITY;
GO

ALTER TABLE [Documents] ADD [IsArchive] bit NOT NULL DEFAULT CAST(0 AS bit);
GO

ALTER TABLE [Documents] ADD [IsSignatureExists] bit NOT NULL DEFAULT CAST(0 AS bit);
GO

ALTER TABLE [Documents] ADD [SignById] uniqueidentifier NULL;
GO

ALTER TABLE [Documents] ADD [SignDate] datetime2 NULL;
GO

ALTER TABLE [DocumentAuditTrails] ADD [Comment] nvarchar(max) NULL;
GO

ALTER TABLE [CompanyProfiles] ADD [AllowPdfSignature] bit NOT NULL DEFAULT CAST(0 AS bit);
GO

CREATE TABLE [AllowFileExtensions] (
    [Id] uniqueidentifier NOT NULL,
    [FileType] int NOT NULL,
    [Extension] nvarchar(max) NULL,
    CONSTRAINT [PK_AllowFileExtensions] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [Clients] (
    [Id] uniqueidentifier NOT NULL,
    [CompanyName] nvarchar(max) NULL,
    [ContactPerson] nvarchar(max) NULL,
    [Email] nvarchar(max) NULL,
    [PhoneNumber] nvarchar(max) NULL,
    [Address] nvarchar(max) NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [ModifiedDate] datetime2 NOT NULL,
    [ModifiedBy] uniqueidentifier NOT NULL,
    [DeletedDate] datetime2 NULL,
    [DeletedBy] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_Clients] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [CustomCategories] (
    [Id] uniqueidentifier NOT NULL,
    [Name] nvarchar(max) NULL,
    [ParentId] uniqueidentifier NULL,
    CONSTRAINT [PK_CustomCategories] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [DocumentSignatures] (
    [Id] uniqueidentifier NOT NULL,
    [DocumentId] uniqueidentifier NOT NULL,
    [SignatureUserId] uniqueidentifier NOT NULL,
    [SignatureUrl] nvarchar(max) NULL,
    [SignatureDate] datetime2 NULL,
    CONSTRAINT [PK_DocumentSignatures] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_DocumentSignatures_Documents_DocumentId] FOREIGN KEY ([DocumentId]) REFERENCES [Documents] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_DocumentSignatures_Users_SignatureUserId] FOREIGN KEY ([SignatureUserId]) REFERENCES [Users] ([Id]) ON DELETE NO ACTION
);
GO

CREATE TABLE [FileRequests] (
    [Id] uniqueidentifier NOT NULL,
    [Subject] nvarchar(max) NULL,
    [Email] nvarchar(max) NULL,
    [Password] nvarchar(max) NULL,
    [MaxDocument] int NULL,
    [SizeInMb] int NULL,
    [AllowExtension] nvarchar(max) NULL,
    [FileRequestStatus] int NOT NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedById] uniqueidentifier NOT NULL,
    [LinkExpiryTime] datetime2 NULL,
    [IsLinkExpired] bit NOT NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_FileRequests] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_FileRequests_Users_CreatedById] FOREIGN KEY ([CreatedById]) REFERENCES [Users] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [MatTableSettings] (
    [Id] uniqueidentifier NOT NULL,
    [ScreenName] nvarchar(max) NOT NULL,
    [UserId] uniqueidentifier NULL,
    [SettingsJson] nvarchar(max) NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [ModifiedDate] datetime2 NOT NULL,
    [ModifiedBy] uniqueidentifier NOT NULL,
    [DeletedDate] datetime2 NULL,
    [DeletedBy] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_MatTableSettings] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [PendingTransitions] (
    [TransitionId] uniqueidentifier NOT NULL,
    [FromStepId] uniqueidentifier NOT NULL,
    [ToStepId] uniqueidentifier NOT NULL,
    [TransitionName] nvarchar(max) NULL,
    CONSTRAINT [PK_PendingTransitions] PRIMARY KEY ([TransitionId])
);
GO

CREATE TABLE [Workflows] (
    [Id] uniqueidentifier NOT NULL,
    [Name] nvarchar(max) NULL,
    [Description] nvarchar(max) NULL,
    [IsWorkflowSetup] bit NOT NULL,
    [UserId] uniqueidentifier NOT NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [ModifiedDate] datetime2 NOT NULL,
    [ModifiedBy] uniqueidentifier NOT NULL,
    [DeletedDate] datetime2 NULL,
    [DeletedBy] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_Workflows] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Workflows_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE NO ACTION
);
GO

CREATE TABLE [FileRequestDocuments] (
    [Id] uniqueidentifier NOT NULL,
    [Name] nvarchar(max) NULL,
    [Url] nvarchar(max) NULL,
    [FileRequestId] uniqueidentifier NOT NULL,
    [FileRequestDocumentStatus] int NOT NULL,
    [ApprovedRejectedDate] datetime2 NULL,
    [ApprovalOrRjectedById] uniqueidentifier NULL,
    [Reason] nvarchar(max) NULL,
    [CreatedDate] datetime2 NOT NULL,
    CONSTRAINT [PK_FileRequestDocuments] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_FileRequestDocuments_FileRequests_FileRequestId] FOREIGN KEY ([FileRequestId]) REFERENCES [FileRequests] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_FileRequestDocuments_Users_ApprovalOrRjectedById] FOREIGN KEY ([ApprovalOrRjectedById]) REFERENCES [Users] ([Id])
);
GO

CREATE TABLE [WorkflowInstances] (
    [Id] uniqueidentifier NOT NULL,
    [WorkflowId] uniqueidentifier NOT NULL,
    [DocumentId] uniqueidentifier NOT NULL,
    [Status] int NOT NULL,
    [CreatedAt] datetime2 NOT NULL,
    [UpdatedAt] datetime2 NOT NULL,
    [InitiatedId] uniqueidentifier NULL,
    CONSTRAINT [PK_WorkflowInstances] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_WorkflowInstances_Documents_DocumentId] FOREIGN KEY ([DocumentId]) REFERENCES [Documents] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_WorkflowInstances_Users_InitiatedId] FOREIGN KEY ([InitiatedId]) REFERENCES [Users] ([Id]),
    CONSTRAINT [FK_WorkflowInstances_Workflows_WorkflowId] FOREIGN KEY ([WorkflowId]) REFERENCES [Workflows] ([Id])
);
GO

CREATE TABLE [WorkflowSteps] (
    [Id] uniqueidentifier NOT NULL,
    [WorkflowId] uniqueidentifier NOT NULL,
    [StepName] nvarchar(max) NULL,
    [CreatedAt] datetime2 NOT NULL,
    [UpdatedAt] datetime2 NOT NULL,
    [IsSignatureRequired] bit NOT NULL,
    [IsFinal] bit NOT NULL,
    CONSTRAINT [PK_WorkflowSteps] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_WorkflowSteps_Workflows_WorkflowId] FOREIGN KEY ([WorkflowId]) REFERENCES [Workflows] ([Id]) ON DELETE NO ACTION
);
GO

CREATE TABLE [WorkflowStepInstances] (
    [Id] uniqueidentifier NOT NULL,
    [WorkflowInstanceId] uniqueidentifier NOT NULL,
    [StepId] uniqueidentifier NOT NULL,
    [UserId] uniqueidentifier NOT NULL,
    [Status] int NOT NULL,
    [CompletedAt] datetime2 NOT NULL,
    [CreatedAt] datetime2 NOT NULL,
    [UpdatedAt] datetime2 NOT NULL,
    [Comment] nvarchar(max) NULL,
    CONSTRAINT [PK_WorkflowStepInstances] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_WorkflowStepInstances_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]),
    CONSTRAINT [FK_WorkflowStepInstances_WorkflowInstances_WorkflowInstanceId] FOREIGN KEY ([WorkflowInstanceId]) REFERENCES [WorkflowInstances] ([Id]),
    CONSTRAINT [FK_WorkflowStepInstances_WorkflowSteps_StepId] FOREIGN KEY ([StepId]) REFERENCES [WorkflowSteps] ([Id])
);
GO

CREATE TABLE [WorkFlowStepRoles] (
    [WorkflowStepId] uniqueidentifier NOT NULL,
    [RoleId] uniqueidentifier NOT NULL,
    CONSTRAINT [PK_WorkFlowStepRoles] PRIMARY KEY ([WorkflowStepId], [RoleId]),
    CONSTRAINT [FK_WorkFlowStepRoles_Roles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [Roles] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_WorkFlowStepRoles_WorkflowSteps_WorkflowStepId] FOREIGN KEY ([WorkflowStepId]) REFERENCES [WorkflowSteps] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [WorkflowStepUsers] (
    [WorkflowStepId] uniqueidentifier NOT NULL,
    [UserId] uniqueidentifier NOT NULL,
    CONSTRAINT [PK_WorkflowStepUsers] PRIMARY KEY ([WorkflowStepId], [UserId]),
    CONSTRAINT [FK_WorkflowStepUsers_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_WorkflowStepUsers_WorkflowSteps_WorkflowStepId] FOREIGN KEY ([WorkflowStepId]) REFERENCES [WorkflowSteps] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [WorkflowTransitions] (
    [Id] uniqueidentifier NOT NULL,
    [Name] nvarchar(max) NULL,
    [WorkflowId] uniqueidentifier NOT NULL,
    [FromStepId] uniqueidentifier NOT NULL,
    [ToStepId] uniqueidentifier NOT NULL,
    [Condition] nvarchar(max) NULL,
    [CreatedAt] datetime2 NOT NULL,
    [UpdatedAt] datetime2 NOT NULL,
    [IsFirstTransaction] bit NOT NULL,
    [Days] int NULL,
    [Hours] int NULL,
    [Minutes] int NULL,
    [IsUploadDocumentVersion] bit NOT NULL,
    CONSTRAINT [PK_WorkflowTransitions] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_WorkflowTransitions_WorkflowSteps_FromStepId] FOREIGN KEY ([FromStepId]) REFERENCES [WorkflowSteps] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_WorkflowTransitions_WorkflowSteps_ToStepId] FOREIGN KEY ([ToStepId]) REFERENCES [WorkflowSteps] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_WorkflowTransitions_Workflows_WorkflowId] FOREIGN KEY ([WorkflowId]) REFERENCES [Workflows] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [WorkflowInstanceEmailSenders] (
    [Id] uniqueidentifier NOT NULL,
    [WorkflowStepInstanceId] uniqueidentifier NOT NULL,
    [WorkflowTransitionId] uniqueidentifier NOT NULL,
    [CreatedAt] datetime2 NOT NULL,
    CONSTRAINT [PK_WorkflowInstanceEmailSenders] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_WorkflowInstanceEmailSenders_WorkflowStepInstances_WorkflowStepInstanceId] FOREIGN KEY ([WorkflowStepInstanceId]) REFERENCES [WorkflowStepInstances] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_WorkflowInstanceEmailSenders_WorkflowTransitions_WorkflowTransitionId] FOREIGN KEY ([WorkflowTransitionId]) REFERENCES [WorkflowTransitions] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [WorkflowTransitionInstances] (
    [Id] uniqueidentifier NOT NULL,
    [Status] int NOT NULL,
    [WorkflowTransitionId] uniqueidentifier NOT NULL,
    [WorkflowInstanceId] uniqueidentifier NOT NULL,
    [CreatedAt] datetime2 NOT NULL,
    [UpdatedAt] datetime2 NOT NULL,
    [Comment] nvarchar(max) NULL,
    [PerformById] uniqueidentifier NULL,
    CONSTRAINT [PK_WorkflowTransitionInstances] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_WorkflowTransitionInstances_Users_PerformById] FOREIGN KEY ([PerformById]) REFERENCES [Users] ([Id]),
    CONSTRAINT [FK_WorkflowTransitionInstances_WorkflowInstances_WorkflowInstanceId] FOREIGN KEY ([WorkflowInstanceId]) REFERENCES [WorkflowInstances] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_WorkflowTransitionInstances_WorkflowTransitions_WorkflowTransitionId] FOREIGN KEY ([WorkflowTransitionId]) REFERENCES [WorkflowTransitions] ([Id]) ON DELETE CASCADE
);
GO

CREATE INDEX [IX_UserNotifications_FileRequestDocumentId] ON [UserNotifications] ([FileRequestDocumentId]);
GO

CREATE INDEX [IX_UserNotifications_WorkflowInstanceId] ON [UserNotifications] ([WorkflowInstanceId]);
GO

CREATE INDEX [IX_DocumentVersions_SignById] ON [DocumentVersions] ([SignById]);
GO

CREATE INDEX [IX_Documents_ClientId] ON [Documents] ([ClientId]);
GO

CREATE INDEX [IX_Documents_SignById] ON [Documents] ([SignById]);
GO

CREATE INDEX [IX_DocumentSignatures_DocumentId] ON [DocumentSignatures] ([DocumentId]);
GO

CREATE INDEX [IX_DocumentSignatures_SignatureUserId] ON [DocumentSignatures] ([SignatureUserId]);
GO

CREATE INDEX [IX_FileRequestDocuments_ApprovalOrRjectedById] ON [FileRequestDocuments] ([ApprovalOrRjectedById]);
GO

CREATE INDEX [IX_FileRequestDocuments_FileRequestId] ON [FileRequestDocuments] ([FileRequestId]);
GO

CREATE INDEX [IX_FileRequests_CreatedById] ON [FileRequests] ([CreatedById]);
GO

CREATE INDEX [IX_WorkflowInstanceEmailSenders_WorkflowStepInstanceId] ON [WorkflowInstanceEmailSenders] ([WorkflowStepInstanceId]);
GO

CREATE INDEX [IX_WorkflowInstanceEmailSenders_WorkflowTransitionId] ON [WorkflowInstanceEmailSenders] ([WorkflowTransitionId]);
GO

CREATE INDEX [IX_WorkflowInstances_DocumentId] ON [WorkflowInstances] ([DocumentId]);
GO

CREATE INDEX [IX_WorkflowInstances_InitiatedId] ON [WorkflowInstances] ([InitiatedId]);
GO

CREATE INDEX [IX_WorkflowInstances_WorkflowId] ON [WorkflowInstances] ([WorkflowId]);
GO

CREATE INDEX [IX_Workflows_UserId] ON [Workflows] ([UserId]);
GO

CREATE INDEX [IX_WorkflowStepInstances_StepId] ON [WorkflowStepInstances] ([StepId]);
GO

CREATE INDEX [IX_WorkflowStepInstances_UserId] ON [WorkflowStepInstances] ([UserId]);
GO

CREATE INDEX [IX_WorkflowStepInstances_WorkflowInstanceId] ON [WorkflowStepInstances] ([WorkflowInstanceId]);
GO

CREATE INDEX [IX_WorkFlowStepRoles_RoleId] ON [WorkFlowStepRoles] ([RoleId]);
GO

CREATE INDEX [IX_WorkflowSteps_WorkflowId] ON [WorkflowSteps] ([WorkflowId]);
GO

CREATE INDEX [IX_WorkflowStepUsers_UserId] ON [WorkflowStepUsers] ([UserId]);
GO

CREATE INDEX [IX_WorkflowTransitionInstances_PerformById] ON [WorkflowTransitionInstances] ([PerformById]);
GO

CREATE INDEX [IX_WorkflowTransitionInstances_WorkflowInstanceId] ON [WorkflowTransitionInstances] ([WorkflowInstanceId]);
GO

CREATE INDEX [IX_WorkflowTransitionInstances_WorkflowTransitionId] ON [WorkflowTransitionInstances] ([WorkflowTransitionId]);
GO

CREATE INDEX [IX_WorkflowTransitions_FromStepId] ON [WorkflowTransitions] ([FromStepId]);
GO

CREATE INDEX [IX_WorkflowTransitions_ToStepId] ON [WorkflowTransitions] ([ToStepId]);
GO

CREATE INDEX [IX_WorkflowTransitions_WorkflowId] ON [WorkflowTransitions] ([WorkflowId]);
GO

ALTER TABLE [Documents] ADD CONSTRAINT [FK_Documents_Clients_ClientId] FOREIGN KEY ([ClientId]) REFERENCES [Clients] ([Id]);
GO

ALTER TABLE [Documents] ADD CONSTRAINT [FK_Documents_Users_SignById] FOREIGN KEY ([SignById]) REFERENCES [Users] ([Id]);
GO

ALTER TABLE [DocumentVersions] ADD CONSTRAINT [FK_DocumentVersions_Users_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [Users] ([Id]);
GO

ALTER TABLE [DocumentVersions] ADD CONSTRAINT [FK_DocumentVersions_Users_SignById] FOREIGN KEY ([SignById]) REFERENCES [Users] ([Id]);
GO

ALTER TABLE [UserNotifications] ADD CONSTRAINT [FK_UserNotifications_FileRequestDocuments_FileRequestDocumentId] FOREIGN KEY ([FileRequestDocumentId]) REFERENCES [FileRequestDocuments] ([Id]);
GO

ALTER TABLE [UserNotifications] ADD CONSTRAINT [FK_UserNotifications_WorkflowInstances_WorkflowInstanceId] FOREIGN KEY ([WorkflowInstanceId]) REFERENCES [WorkflowInstances] ([Id]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250214054535_Version_V5', N'8.0.13');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

--Screens
INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted], [OrderNo]) VALUES 
(N'a676aa9b-8ccb-4608-8e21-2cdd9a37fd99', N'Current Workflow', CAST(N'2024-12-23T06:58:59.9133431' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T06:58:59.9133333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0, NULL)
INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted], [OrderNo]) VALUES 
(N'efe7d58a-1c33-4f2a-9b7b-3e1dff6b5664', N'Workflows', CAST(N'2024-12-23T06:58:44.2400200' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T06:58:44.2400000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0, NULL)
INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted], [OrderNo]) VALUES 
(N'309f72e8-6e93-43fa-9203-808b030a33f7', N'Workflow Settings', CAST(N'2024-12-23T06:58:23.6071202' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T06:58:23.6333333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0, NULL)
INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted], [OrderNo]) VALUES 
(N'33c5442e-2844-497c-af00-9cda5a6fc826', N'Workflow Logs', CAST(N'2024-12-23T06:59:21.6608642' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T06:59:21.6666667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0, NULL)
INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted], [OrderNo]) VALUES 
(N'ffee08a0-35e0-485a-a335-e455fb59e344', N'File Request', CAST(N'2024-12-23T06:59:21.6608642' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T06:59:21.6666667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0, NULL)
INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted], [OrderNo]) VALUES 
(N'8130904f-4e5b-47d4-8acf-c9cff36d48a4', N'Archive Documents', CAST(N'2024-12-23T06:59:21.6608642' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T06:59:21.6666667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0, NULL)
INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted], [OrderNo]) VALUES 
(N'eb342fd3-836f-437c-9b6b-b7e4188fb49c', N'Bulk Document Uploads', CAST(N'2024-12-23T06:59:21.6608642' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T06:59:21.6666667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0, NULL)
INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted], [OrderNo]) VALUES 
(N'dc075340-895b-41c0-93da-1767f097a64b', N'Clients', CAST(N'2024-12-23T06:59:21.6608642' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T06:59:21.6666667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0, NULL)


--Operations
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'e305603b-efe3-4488-b3a1-05538636b3f9', N'Workflow Logs', CAST(N'2024-12-23T07:07:17.3074050' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T07:07:17.3066667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0);
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'5c578ad3-7603-4ff0-a09b-1e7767c3da0f', N'Edit Workflow Settings', CAST(N'2024-12-23T07:05:24.1441246' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T07:05:24.1433333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0);
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'899dab9d-9a22-4f8e-9ce6-31042ef37cf1', N'Add Workflow Settings', CAST(N'2024-12-23T07:04:27.0374796' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T07:04:56.3595385' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'bb30ce8b-7997-4050-bdf7-70fcfbdfe072', N'Workflows', CAST(N'2024-12-23T07:06:52.8536812' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T07:06:52.8533333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'd21e68ba-c59e-4b3f-8125-85f0eff382e4', N'Current Workflow', CAST(N'2024-12-23T07:07:06.8305394' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T07:07:06.8300000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'4232d0fd-b6e7-4a61-b2f0-f247466cf5b2', N'View Workflow Settings', CAST(N'2024-12-23T07:28:39.6889693' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T07:28:39.7033333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'e14a7417-23cc-4327-892e-f9bf7a3f8c84', N'Start Workflow', CAST(N'2024-12-23T11:53:59.0738679' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T11:53:59.0900000' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'8bede5b8-debc-47a6-aeab-ff695cf68421', N'Delete Workflow Settings', CAST(N'2024-12-23T07:05:09.5818191' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T07:05:09.5833333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'b9c0eea9-6d73-4181-89f0-aa060a268e47', N'Manage Indexing', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'caec2939-374a-4fc9-8659-e4f3c625b602', N'Add File Request', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'6294cfd8-30b5-4f43-8e2e-1a21d81711b0', N'Edit File Request', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'dde44280-9105-449b-8cdb-4e575d699a04', N'Delete File Request', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'78877a7f-55a5-40fb-96e0-9ef9fa5db4d6', N'View File Request', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'6dfe1243-4464-48ac-8913-8c943c13415e', N'Approved File Request Documents', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'3792eac2-d9ef-467e-8a6f-321f20f1b831', N'Rejected File Request Documents', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'5b65110d-1ac7-444d-86da-569520f88989', N'Archive Document', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'652c4cba-ab06-4345-9795-452088a3fd47', N'Restore Document', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'11a649a2-1430-4b1e-9166-eb00bd18c1c4', N'Bulk Document Uploads', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'10159009-0d83-46f1-8841-7c3ff2a66f08', N'View Clients', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'5c429835-b3b4-4bc1-8c79-aefec27fc18f', N'Add Clients', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'5ec34af3-4679-4807-bd21-4560852cd241', N'Edit Clients', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'68368c17-7dfc-42c8-96bb-51f1cc8064a6', N'Delete Clients', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'1040ef78-4172-4f7e-aff0-16a7818b184a', N'Allow To See File Request', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)

--ScreenOperations
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'5d4859df-2354-4e77-b3c2-f9eb85f7836d', N'd21e68ba-c59e-4b3f-8125-85f0eff382e4', N'a676aa9b-8ccb-4608-8e21-2cdd9a37fd99', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'1eb6b640-de77-4d96-8487-222367b1233d', N'bb30ce8b-7997-4050-bdf7-70fcfbdfe072', N'efe7d58a-1c33-4f2a-9b7b-3e1dff6b5664', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'95322722-6362-41ac-8165-9c64076399fb', N'e305603b-efe3-4488-b3a1-05538636b3f9', N'33c5442e-2844-497c-af00-9cda5a6fc826', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'c45ee6ab-20a8-44b2-ae88-8fcbf4fbd54d', N'5c578ad3-7603-4ff0-a09b-1e7767c3da0f', N'309f72e8-6e93-43fa-9203-808b030a33f7', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'f2bb13d3-c376-42ab-b804-952dfd8ce164', N'899dab9d-9a22-4f8e-9ce6-31042ef37cf1', N'309f72e8-6e93-43fa-9203-808b030a33f7', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'f7dc4930-c87f-429d-be36-6b9817adf1e8', N'4232d0fd-b6e7-4a61-b2f0-f247466cf5b2', N'309f72e8-6e93-43fa-9203-808b030a33f7', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'db16125a-e16e-498f-980f-7f8f397dd920', N'8bede5b8-debc-47a6-aeab-ff695cf68421', N'309f72e8-6e93-43fa-9203-808b030a33f7', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'3729cbe2-302d-4096-934e-b4cad63711e3', N'e14a7417-23cc-4327-892e-f9bf7a3f8c84', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'e37e63ee-3aa4-4521-b913-95d48b8c831a', N'e14a7417-23cc-4327-892e-f9bf7a3f8c84', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'd779248e-b029-4228-bd1d-a6d52fe4832b', N'b9c0eea9-6d73-4181-89f0-aa060a268e47', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'0c066eaa-8200-4846-9453-ea0248b0bde4', N'b9c0eea9-6d73-4181-89f0-aa060a268e47', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'07767bf0-ca74-423b-9ad2-0e2a0bd1087b', N'A441D0F5-84CB-40B1-B1C3-C8C971E68F80', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'11d3365a-95a3-481b-8fb3-cd59dfd2e0c3', N'2EA6BA08-EB36-4E34-92D9-F1984C908B31', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'd1f39f95-d550-474b-96fa-99b097b34c1b', N'A8DD972D-E758-4571-8D39-C6FEC74B361B', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'7999014d-dfcd-4f2c-b6d8-cf66571d1fb7', N'63ED1277-1DB5-4CF7-8404-3E3426CB4BC5', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'e945d35f-d3f6-46e7-9723-a62f89b2022e', N'595A769D-F7EF-45F3-9F9E-60C58C5E1542', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'e0eb3f5b-a325-45ff-b20d-d26b18bcc8ae', N'6719A065-8A4A-4350-8582-BFC41CE283FB', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'dcf6f998-7276-4a1c-aba1-8513f2eaebad', N'0AAAFAF0-CE63-4055-9204-DB4B03160CDE', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'764568df-718a-4a10-a6b5-a11523b22c19', N'E3EBB06C-1D2C-4FA8-A3E8-612ADA02D4AE', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'97ab4ba3-be33-4d8b-9363-86cf013f592c', N'caec2939-374a-4fc9-8659-e4f3c625b602', N'ffee08a0-35e0-485a-a335-e455fb59e344', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'9eac28ed-e662-4c9c-8bf9-8e14d7568afc', N'6294cfd8-30b5-4f43-8e2e-1a21d81711b0', N'ffee08a0-35e0-485a-a335-e455fb59e344', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'bc56d098-f652-430c-be0d-210090a298cb', N'dde44280-9105-449b-8cdb-4e575d699a04', N'ffee08a0-35e0-485a-a335-e455fb59e344', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'38862aeb-f2d6-4256-b506-3298f12d0f03', N'78877a7f-55a5-40fb-96e0-9ef9fa5db4d6', N'ffee08a0-35e0-485a-a335-e455fb59e344', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'5c7f8415-59ac-4ae7-a622-a5729aaac8ab', N'6dfe1243-4464-48ac-8913-8c943c13415e', N'ffee08a0-35e0-485a-a335-e455fb59e344', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'1c0a486d-53a9-4239-97ae-233366a63646', N'3792eac2-d9ef-467e-8a6f-321f20f1b831', N'ffee08a0-35e0-485a-a335-e455fb59e344', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'930af13c-158e-493a-ba7c-6406587b5286', N'5b65110d-1ac7-444d-86da-569520f88989', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'670fc04b-7367-4984-8aeb-037705d7bfc8', N'5b65110d-1ac7-444d-86da-569520f88989', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'5dbdba2a-17f7-48f9-989c-52322fd24d8c', N'F0BD06DA-4E1B-41BC-ABB0-AC833392C880', N'8130904f-4e5b-47d4-8acf-c9cff36d48a4', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'0a74c66d-10ec-43a8-ab35-7b45ce0d6092', N'6719A065-8A4A-4350-8582-BFC41CE283FB', N'8130904f-4e5b-47d4-8acf-c9cff36d48a4', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'00e99d70-a221-47e6-b56f-cc19e154b6c6', N'652c4cba-ab06-4345-9795-452088a3fd47', N'8130904f-4e5b-47d4-8acf-c9cff36d48a4', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'5b5e4d58-cdfc-4e4b-8083-9b497230af4b', N'229AD778-C7D3-4F5F-AB52-24B537C39514', N'8130904f-4e5b-47d4-8acf-c9cff36d48a4', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'8105bd15-f1e3-435b-be45-38cf8dea8800', N'1E2453BD-A1CD-4E8F-B5B3-7C536CE7FED5', N'8130904f-4e5b-47d4-8acf-c9cff36d48a4', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'617c390b-99c7-4a22-bd16-154aecc63169', N'595A769D-F7EF-45F3-9F9E-60C58C5E1542', N'8130904f-4e5b-47d4-8acf-c9cff36d48a4', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'35746e9b-7bb3-4272-b0f3-5abde75fe6cd', N'11a649a2-1430-4b1e-9166-eb00bd18c1c4', N'eb342fd3-836f-437c-9b6b-b7e4188fb49c', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'82e66203-b6d6-440e-8c9b-733163b574a1', N'10159009-0d83-46f1-8841-7c3ff2a66f08', N'dc075340-895b-41c0-93da-1767f097a64b', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'c8e790f2-6fb6-412a-a2fb-45dc579cae43', N'5c429835-b3b4-4bc1-8c79-aefec27fc18f', N'dc075340-895b-41c0-93da-1767f097a64b', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'c5b79883-882f-4e1f-bbbe-f6ed055484ca', N'5ec34af3-4679-4807-bd21-4560852cd241', N'dc075340-895b-41c0-93da-1767f097a64b', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'2c5ac3ce-a7e8-4feb-80b7-8fe10d412631', N'68368c17-7dfc-42c8-96bb-51f1cc8064a6', N'dc075340-895b-41c0-93da-1767f097a64b', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'8a2e6320-2aa2-496c-9e72-0cd7be0140df', N'1040ef78-4172-4f7e-aff0-16a7818b184a', N'ffee08a0-35e0-485a-a335-e455fb59e344', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)


--PageHelpers
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'af147be0-b4ae-48ba-aa81-2dc3cb106c6e', N'MANAGE_WORKFLOW', N'Manage Workflow', N'<ul><li><h3><strong>Manage Workflow Overview</strong></h3></li><li>The <strong>Manage Workflow</strong> feature allows users to efficiently create, edit, and customize workflows as needed. This functionality is designed to ensure flexibility and control over workflow management. Here''s how it works:</li><li><h4><strong>Creating a Workflow</strong></h4></li><li>If no workflows have been created, users can start by building a new workflow:</li><li><strong>Define Workflow Details</strong>: Provide a unique name and description for the workflow.</li><li><strong>Add Workflow Steps</strong>: Create the necessary steps that outline the workflow process.</li><li><strong>Set Workflow Transitions</strong>: Define the transitions between steps, specifying conditions or rules for movement.</li><li>Once the workflow is created, users can manage and update it as required.</li><li><h4><strong>Editing an Existing Workflow</strong></h4></li><li>For workflows that have already been created, users have the ability to make updates:</li><li><strong>Edit Workflow Name</strong>: Change the name of the workflow to reflect new requirements or corrections.</li><li><strong>Edit Workflow Step Name</strong>: Modify the names of individual steps within the workflow to ensure clarity or adjust for changes.</li><li><strong>Edit Workflow Transition Name</strong>: Update the names or rules for transitions between workflow steps as needed.</li><li><h3>Flexibility in Management</h3></li><li>The <strong>Manage Workflow</strong> feature is versatile, allowing users to either:</li><li><strong>Create a new workflow</strong> if none exist, or</li><li><strong>Edit an existing workflow</strong> to adapt to evolving needs.</li></ul>', CAST(N'2023-06-03T05:22:44.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-20T05:50:48.5775056' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'c1911262-774f-4be8-9471-455ba4e19b7d', N'WORKFLOWS', N'Workflows', N'<ul><li><h3>Workflow List Page Overview</h3></li><li>The <strong>Workflow List Page</strong> provides a complete overview of all workflows, displaying their statuses and details to help users manage and monitor workflows effectively. It combines visual graphs and detailed information to ensure clarity and usability.</li><li><h4><strong>Key Features</strong></h4></li><li><strong>Comprehensive Workflow Display</strong>:<ul><li>All workflows are listed on this page, categorized by their statuses:<ul><li><strong>Completed</strong>: Workflows that have been fully executed.</li><li><strong>Initiated</strong>: Newly started workflows awaiting progress.</li><li><strong>In Progress</strong>: Ongoing workflows with steps and transitions in process.</li><li><strong>Cancelled</strong>: Workflows that were terminated before completion.</li></ul></li></ul></li><li><strong>Workflow Details in Graphical View</strong>:<ul><li>Workflows are visually represented using graphs, showcasing:<ul><li>The structure of steps and transitions.</li><li><strong>Completed Transitions</strong>: Clearly highlighted.</li><li><strong>Pending Transitions</strong>: Distinctly marked.</li></ul></li><li>This graphical format allows users to quickly understand the workflow’s progress and flow.</li></ul></li><li><strong>Workflow Information Table</strong>:<ul><li>Each workflow is accompanied by a table containing detailed information:<ul><li><strong>Workflow Name</strong>: Unique name of the workflow.</li><li><strong>Workflow Status</strong>: Current status of the workflow (Completed, Initiated, In Progress, Cancelled).</li><li><strong>Initiated By</strong>: The user who initiated the workflow.</li><li><strong>Document Name</strong>: The associated document, if applicable.</li><li><strong>Workflow Step</strong>: The current step(s) in the workflow.</li><li><strong>Workflow Step Status</strong>: Status of each step (Completed, Pending).</li><li><strong>Performed By</strong>: The user or team responsible for a specific step.</li><li><strong>Transition Status</strong>: Indicates the progress of transitions (Completed or Pending).</li></ul></li></ul></li><li><strong>Interactive Details</strong>:<ul><li>Users can click on workflow steps or transitions in the graph or table to access:<ul><li>Detailed descriptions.</li><li>Status history.</li><li>Timestamps and related actions.</li></ul></li></ul></li><li><h3>Benefits</h3></li><li>The <strong>Workflow List Page</strong> provides a holistic view of all workflows, their statuses, and detailed progress information. This ensures users can:</li><li>Track and manage all workflows efficiently.</li><li>Monitor progress visually and in detail.</li><li>Quickly identify completed, pending, or cancelled workflows.</li><li>This page is an essential tool for streamlining workflow operations and ensuring process transparency.</li></ul>', CAST(N'2023-06-03T05:22:44.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-20T06:09:22.8490633' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'aac91fd9-c6df-4c75-937b-775dbfbdc0d7', N'WORKFLOW_SETTINGS', N'Workflow Settings', N'<ul><li><h3><strong>Workflow Settings Overview</strong></h3></li><li>The <strong>Workflow Settings</strong> allow users to create and configure workflows in a structured and straightforward manner. The process is divided into three main steps to ensure ease of understanding and use:</li><li><h4><strong>Step 1: Define Workflow Details</strong></h4></li><li>In this step, users provide the foundational details for their workflow:</li><li><strong>Workflow Name</strong>: Enter a unique and descriptive name for the workflow.</li><li><strong>Description</strong>: Add a brief description to explain the purpose or functionality of the workflow.</li><li>Once these details are entered, users can proceed to the next step.</li><li><h4><strong>Step 2: Create Workflow Steps</strong></h4></li><li>In the second step, users define the specific steps involved in the workflow:</li><li><strong>Add Workflow Steps</strong>: Create individual steps that represent the actions or processes in the workflow.</li><li>Arrange and name the steps according to the workflow’s logic or sequence.</li><li>After defining all the necessary steps, users can move to the final step.</li><li><h4><strong>Step 3: Configure Workflow Transitions</strong></h4></li><li>In this step, users set up the rules and connections between workflow steps:</li><li><strong>Define Transitions</strong>: Specify how the workflow moves from one step to another (e.g., conditions or triggers for moving to the next step).</li><li>Ensure the transitions align with the desired workflow logic.</li></ul>', CAST(N'2023-06-03T05:22:44.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-20T05:51:17.9183460' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'9a30dbb2-811b-4e2a-aea1-99ff1fe1ccc2', N'WORKFLOW_LOGS', N'Workflow Logs', N'<ul><li><h3>Workflow Logs Page Overview</h3></li><li>The <strong>Workflow Logs Page</strong> provides a comprehensive log of every step and transition within a workflow. It helps users track the detailed progression of workflows, offering transparency and visibility into the actions and decisions made at each stage.</li><li><h4><strong>Key Features</strong></h4></li><li><strong>Detailed Step and Transition Logs</strong>:<ul><li>Every step and transition in the workflow is logged with the following details:<ul><li><strong>Name</strong>: The name of the workflow step or transition.</li><li><strong>Status</strong>: Current status of the step or transition (e.g., Completed, Pending, In Progress).</li><li><strong>Initiated By</strong>: The user who initiated the step or transition.</li><li><strong>Initiated Date</strong>: The date and time when the step or transition was initiated.</li><li><strong>Document Name</strong>: The name of the document associated with the workflow.</li><li><strong>Transition Name</strong>: The name of the transition between steps.</li><li><strong>Steps</strong>: The specific step(s) in the workflow.</li><li><strong>Transition Status</strong>: Status of the transition (e.g., Completed, Pending).</li><li><strong>Performed By</strong>: The user or team who performed the transition or step.</li><li><strong>Transition Date</strong>: The date and time when the transition occurred.</li><li><strong>Comment</strong>: Any additional comments or notes added regarding the step or transition.</li></ul></li></ul></li><li><strong>Complete Workflow Tracking</strong>:<ul><li>The logs track each workflow step from start to finish, offering a complete audit trail of all actions taken during the workflow''s lifecycle.</li><li>Users can quickly see when each step was initiated, who performed the actions, and if any comments were added, providing full insight into the workflow''s progress and changes.</li></ul></li><li><strong>Easy Navigation and Filtering</strong>:<ul><li>The log entries are organized and displayed in a table format, making it easy for users to scroll through, filter, or search for specific steps or transitions.</li><li>Users can filter by workflow name, status, initiated date, transition date, and other fields to find the exact log details they need.</li></ul></li><li><h3>Benefits</h3></li><li>The <strong>Workflow Logs Page</strong> provides an in-depth look at the execution of each workflow, ensuring that users can:</li><li><strong>Track Workflow Progress</strong>: View every step and transition with timestamps and status updates.</li><li><strong>Maintain Transparency</strong>: Ensure all actions are recorded with details about who performed each step and when.</li><li><strong>Access Full Audit Trails</strong>: Review comments, dates, and statuses to verify workflow history and identify areas for improvement.</li><li>This page is crucial for monitoring and reviewing workflows, offering full visibility into their progression and actions taken at every stage.</li></ul>', CAST(N'2023-06-03T05:22:44.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-20T06:15:23.2890506' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'4654e4de-f167-4329-8a43-cd0e56f430e1', N'CURRENT_WORKFLOWS', N'Current Workflows', N'<ul><li><h3>Current Workflow Page Overview</h3></li><li>The <strong>Current Workflow Page</strong> provides users with a personalized view of workflows they have rights to manage or view. This page displays only the workflows associated with the user, ensuring they can easily track and manage their tasks.</li><li><h4><strong>Key Features</strong></h4></li><li><strong>User-Specific Workflow Display</strong>:<ul><li>This page shows <strong>only the workflows</strong> that the user has permission to access and manage.</li><li>The workflows are categorized based on their statuses:<ul><li><strong>Completed</strong>: Workflows that the user has finished or completed steps for.</li><li><strong>Initiated</strong>: Workflows the user has started but are awaiting further progress.</li><li><strong>In Progress</strong>: Workflows where the user is actively involved in ongoing steps.</li><li><strong>Cancelled</strong>: Workflows the user has been part of that were cancelled before completion.</li></ul></li></ul></li><li><strong>Workflow Details in Graphical View</strong>:<ul><li>The workflows are represented graphically to show:<ul><li>The flow of steps and transitions.</li><li><strong>Completed Transitions</strong>: Clearly marked for easy recognition.</li><li><strong>Pending Transitions</strong>: Distinctly highlighted to indicate remaining tasks.</li></ul></li></ul></li><li><strong>Workflow Information Table</strong>:<ul><li>For each workflow, users can view detailed information, including:<ul><li><strong>Workflow Name</strong>: Unique name of the workflow.</li><li><strong>Workflow Status</strong>: Current status (Completed, Initiated, In Progress, Cancelled).</li><li><strong>Initiated By</strong>: The user who initiated the workflow.</li><li><strong>Document Name</strong>: Associated document, if applicable.</li><li><strong>Workflow Step</strong>: The current step(s) the user is involved in.</li><li><strong>Workflow Step Status</strong>: Status of each step (Completed, Pending).</li><li><strong>Performed By</strong>: User(s) responsible for the steps.</li><li><strong>Transition Status</strong>: Whether transitions are completed or pending.</li></ul></li></ul></li><li><strong>Interactive Details</strong>:<ul><li>Users can click on any step or transition to access:<ul><li>Detailed information about that step/transition.</li><li>History and status of the action.</li><li>Relevant timestamps and actions taken.</li></ul></li></ul></li><li><h3>Benefits</h3></li><li>The <strong>Current Workflow Page</strong> is designed for users to have a focused, user-specific view of workflows they have rights to manage. This ensures:</li><li><strong>Personalized Workflow Management</strong>: Only workflows the user is authorized to access are shown.</li><li><strong>Efficient Tracking</strong>: Users can easily track progress of workflows they’re involved in.</li><li><strong>Clear Visibility</strong>: Understanding of the workflow status, transitions, and who is performing each step.</li><li>This page provides a secure and streamlined experience for users to manage their assigned workflows effectively.</li></ul>', CAST(N'2023-06-03T05:22:44.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-20T06:11:47.5381909' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'39ca4a0c-97a7-44a4-9f99-e98ed7c0dad7', N'MANAGE_ALLOW_FILE_EXTENSION', N'Manage Allow File Extension', N'<p><strong>Manage Allowed File Extensions</strong></p><p>This functionality allows users to control which file types are permitted for upload in the application. Users can easily configure allowed file extensions by selecting the desired file types and specifying their extensions in a provided configuration interface. Here''s how it works:</p><ol><li><strong>Select File Types</strong>: Users can choose from a predefined list of file types (e.g., images, documents, videos) or manually add custom types.</li><li><strong>Add Extensions</strong>: For each file type, users can specify the associated file extensions (e.g., .jpg, .pdf, .mp4).</li><li><strong>Apply Changes</strong>: Once configured, the application will enforce these rules, ensuring only the specified file types can be uploaded.</li><li><strong>Easy Management</strong>: Users can modify, add, or remove allowed extensions anytime, making the system flexible and easy to update.</li></ol><p>This functionality simplifies file type management and ensures compliance with application requirements or security policies.</p>', CAST(N'2023-06-02T17:31:21.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-24T07:14:19.6096232' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'6a845385-7964-463c-9064-09efa0ca3c6b', N'DOCUMENT_SIGNATURE', N'Document Signature', N'<p><strong>Document Signature Functionality</strong></p><p>The <strong>Document Signature</strong> feature allows users to digitally sign documents with ease. This functionality is designed to make the process simple, secure, and efficient, eliminating the need for printing and manual signatures.</p><h3>How It Works:</h3><ol><li><strong>Initiating the Signature Process:</strong><ul><li>Users can click on the <strong>"Document Signature"</strong> button for any document.</li><li>A <strong>popup window</strong> opens, providing options to add a signature.</li></ul></li><li><strong>Applying the Signature:</strong><ul><li>Users can <strong>draw</strong> their signature using a touchscreen or mouse.</li><li>Alternatively, they can <strong>type</strong> their name and choose from various font styles to create a professional-looking signature.</li><li>The signature can be placed anywhere on the document by dragging it to the desired location.</li></ul></li><li><strong>Additional Functionalities:</strong><ul><li><strong>PDF Signature Integration:</strong> Users can directly sign PDFs without converting file formats.</li><li>The <strong>Company Profile</strong> section allows users to include their company details, such as &nbsp;in the PDF signature.</li></ul></li></ol><h3>Key Features:</h3><ul><li><strong>Interactive and User-Friendly:</strong> The popup makes it easy to apply signatures in just a few clicks.</li><li><strong>Professional Branding:</strong> Integrate company details with your signature for added authenticity.</li><li><strong>Secure Signing:</strong> Digital signatures are encrypted to ensure document integrity.</li><li><strong>Flexibility:</strong> Customize the signature and include additional annotations like dates or initials.</li></ul><h3>Benefits:</h3><ul><li><strong>Streamlined Workflow:</strong> Quickly sign and finalize documents without printing or scanning.</li><li><strong>Enhanced Professionalism:</strong> Signatures with company branding make documents look polished and credible.</li><li><strong>Secure and Reliable:</strong> All signed documents are protected with advanced encryption to ensure they remain tamper-proof.</li></ul><p>With the <strong>Document Signature</strong> feature, signing documents becomes fast, professional, and secure, offering users the flexibility and tools they need to manage their documents seamlessly.</p>', CAST(N'2023-06-02T17:31:21.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-28T07:43:59.5604299' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'5ec9fb94-f79e-4b23-bd5b-066001a135d7', N'FILE_REQUEST', N'File Request Functionality', N'<h2>File Request Functionality</h2><p>The <strong>File Request</strong> feature simplifies document collection by allowing you to generate unique links, share them with users, and review uploaded documents. Here''s how it works:</p><h2>Key Features:</h2><p><strong>1.Generate Link</strong>:</p><ul><li>Create a unique link for a file request.</li><li>Share this link with users to allow them to upload the required documents.</li></ul><p><strong>2.Upload Documents</strong>:</p><p>Users can upload documents directly via the link you provide.</p><p>You can set the following parameters when creating a request:</p><p><strong>Maximum File Size Upload</strong>: Specify the largest file size allowed per upload.</p><p><strong>Maximum Document Upload</strong>: Limit the number of documents a user can upload.</p><ul><li><strong>Allowed File Extensions</strong>: Restrict uploads to specific file types (e.g., PDF, DOCX, JPG).</li></ul><p><strong>3.Review and Manage Requests</strong>:</p><ul><li>View all submissions on the <strong>File Request List</strong> page.</li><li>Approve or reject uploaded documents as necessary.</li></ul><p><strong>4.Request Data List</strong>:<br>Each file request includes the following details:</p><ul><li><strong>Subject</strong>: The purpose or title of the request.</li><li><strong>Email</strong>: The email address associated with the request.</li><li><strong>Maximum File Size Upload</strong>: The size limit for uploaded files.</li><li><strong>Maximum Document Upload</strong>: The number of documents users can upload.</li><li><strong>Allowed File Extensions</strong>: The types of files users can upload.</li><li><strong>Status</strong>: The current status of the request (e.g., Pending, Approved, Rejected).</li><li><strong>Created By</strong>: The user who created the request.</li><li><strong>Created Date</strong>: The date the request was created.</li><li><strong>Link Expiration</strong>: The date the link will no longer be valid.</li></ul><p><strong>5.Manage Requests</strong>:<br>For each file request, you can:</p><ul><li><strong>Edit</strong>: Update the details of the request, such as file size, document limits, or expiration date.</li><li><strong>Delete</strong>: Remove the request entirely.</li><li><strong>Copy Link</strong>: Copy the link to share it with others.</li></ul><h2>How It Works:</h2><h3>1. Creating a File Request:</h3><ul><li>Navigate to the <strong>File Request</strong> page and click "Create New Request."</li><li>Enter details like the subject, allowed file extensions, and upload limits.</li><li>Generate the link and share it with the intended user.</li></ul><h3>2. Uploading Documents:</h3><ul><li>The user clicks the link and uploads their documents according to the criteria you set.</li></ul><h3>3. Reviewing Submissions:</h3><ul><li>Go to the <strong>File Request List</strong> page to view submitted documents.</li><li>Approve or reject submissions as required.</li></ul><h3>4. Managing Links:</h3><ul><li>Use the <strong>Edit</strong> or <strong>Delete</strong> options to modify or remove requests.</li><li>Copy the link anytime for reuse or sharing.</li></ul>', CAST(N'2023-06-02T17:31:21.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2025-01-09T06:19:30.3109183' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'44d08495-12ef-40bd-b777-a94a6c784035', N'FILE_REQUEST_UPLOADED_DOCUMENTS', N'File Request Uploaded Documents', N'<h2>File Request Uploaded Documents</h2><p>The <strong>File Request Uploaded Documents</strong> feature allows you to manage the documents submitted through your file request link. You can review, approve, or reject uploaded files and provide feedback or reasons for rejection.</p><h2>Key Features:</h2><p><strong>1.View Uploaded Documents</strong>:</p><ul><li>Access all documents submitted via the file request link.</li><li>See details such as:<ul><li>File Name</li><li>Upload Date</li><li>Document Status</li><li>Reason</li></ul></li></ul><p><strong>2.Approve Documents</strong>:</p><ul><li>Mark documents as <strong>Approved</strong> if they meet your requirements.</li><li>Approved documents will be saved and marked as finalized.</li></ul><p><strong>3.Reject Documents</strong>:</p><ul><li>Reject documents that do not meet the criteria or need corrections.</li><li>When rejecting a document:<ul><li>Add a <strong>Comment</strong> to explain the reason for rejection.</li><li>This ensures users understand what needs to be corrected or resubmitted.</li></ul></li></ul><p><strong>4.Document Preview</strong>:</p><ul><li>View uploaded documents directly before approving or rejecting them.</li><li>Supports previewing common file types such as PDF, DOCX, JPG, and PNG.</li></ul><p><strong>5.Status Tracking</strong>:</p><ul><li>Each document will have a status indicator:<ul><li><strong>Pending</strong>: Awaiting review.</li><li><strong>Approved</strong>: Accepted and finalized.</li><li><strong>Rejected</strong>: Requires resubmission with a reason provided.</li></ul></li></ul><h2>How It Works:</h2><h3>1. Viewing Uploaded Documents:</h3><ul><li>Go to the <strong>File Request Uploaded Documents</strong> page.</li><li>Select the relevant file request from the list.</li><li>All submitted documents for that request will be displayed.</li></ul><h3>2. Approving Documents:</h3><ul><li>Click on the document you want to approve.</li><li>Review the document using the preview feature.</li><li>If the document meets your requirements, click <strong>Approve</strong>.</li><li>The status will change to <strong>Approved</strong>.</li></ul><h3>3. Rejecting Documents:</h3><ul><li>Click on the document you want to reject.</li><li>Use the preview feature to review the document.</li><li>If the document does not meet the requirements:<ul><li>Click <strong>Reject</strong>.</li><li>Enter a <strong>Reason for Rejection</strong> in the comment box (e.g., "Incorrect file format" or "Incomplete information").</li><li>Save the rejection and notify the user to resubmit.</li></ul></li></ul><h3>4. Adding Comments for Rejected Documents:</h3><ul><li>When rejecting a document, always provide a clear and actionable comment.</li><li>Examples of comments:<ul><li>"Please upload a file in PDF format."</li><li>"The document is missing required signatures."</li><li>"File size exceeds the maximum limit; please compress and reupload."</li></ul></li></ul><h2>Benefits:</h2><ul><li><strong>Efficient Review</strong>: Quickly review and take action on uploaded documents.</li><li><strong>Clear Communication</strong>: Provide feedback for rejected documents, ensuring users know what to fix.</li><li><strong>Organized Workflow</strong>: Keep track of document statuses with easy-to-use status indicators.</li></ul><p>This feature ensures a smooth and transparent document review process for both you and the users.</p>', CAST(N'2023-06-02T17:31:21.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2025-01-09T06:29:05.5619310' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'8d114f7f-6500-4c33-87c3-d896e2132bcc', N'MANAGE_FILE_REQUEST', N'Manage File Request', N'<p>The <strong>Manage File Request</strong> feature allows you to create, edit, and control your file requests efficiently. This includes setting security options such as a password and defining a link expiration time. Here’s how it works:</p><h2>Key Features:</h2><p><strong>1.Add New File Request</strong>:</p><ul><li>Create a new file request by providing details like:</li></ul><p><strong>Subject</strong>: A clear title for the request.</p><p><strong>Email</strong>: The email address associated with the request.</p><p><strong>Maximum File Size Upload</strong>: Define the largest file size allowed per upload.</p><p><strong>Maximum Document Upload</strong>: Set the maximum number of documents users can upload.</p><p><strong>Allowed File Extensions</strong>: Restrict uploads to specific file types (e.g., PDF, DOCX, JPG).</p><p><strong>Password Protection</strong>: Add a password to secure the upload link.</p><p><strong>Link Expiry Time</strong>: Set a date and time after which the link will no longer be valid.</p><p><strong>2.Edit File Request</strong>:</p><ul><li>Update existing file requests to adjust settings as needed:<ul><li>Change the <strong>Subject</strong>, <strong>Email</strong>, or upload criteria.</li><li>Modify the <strong>Password</strong> or disable it.</li><li>Extend or shorten the <strong>Link Expiry Time</strong>.</li></ul></li></ul><p><strong>3.Secure Uploads</strong>:</p><ul><li>By setting a password, only users with the password can upload files, ensuring additional security.</li></ul><p><strong>4.Link Expiration</strong>:</p><ul><li>The link will automatically expire after the set date and time, preventing further uploads.</li></ul><p><strong>5.Manage File Requests List</strong>:</p><ul><li>View and manage all file requests from a centralized list with the following options:</li></ul><p><strong>Edit</strong>: Update the details of an existing file request.</p><p><strong>Delete</strong>: Remove a file request permanently.</p><p><strong>Copy Link</strong>: Copy the unique link to share it with others.</p><h2>How It Works:</h2><h3>1. Adding a File Request:</h3><ul><li>Go to the <strong>File Request</strong> page and click "Add New Request."</li><li>Fill in the following details:</li></ul><p><strong>Subject</strong>: The purpose of the request.</p><p><strong>Email</strong>: The email address for communication.</p><p><strong>Maximum File Size Upload</strong> and <strong>Maximum Document Upload</strong>.</p><p><strong>Allowed File Extensions</strong>: Specify the types of files you will accept.</p><p><strong>Password Protection</strong>: Create a password to restrict access.</p><p><strong>Link Expiry Time</strong>: Set a specific date and time for the link to expire.</p><ul><li>Save the request to generate the link.</li></ul><h3>2. Editing a File Request:</h3><ul><li>Open the <strong>File Request List</strong> and locate the request you want to modify.</li><li>Click the <strong>Edit</strong> button.</li><li>Adjust any of the request details, such as upload limits, password, or expiry time.</li><li>Save the changes.</li></ul><h3>3. Sharing and Using the Link:</h3><ul><li>Copy the generated link and share it with the intended users.</li><li>If a password is set, ensure the recipient has the password to access the link.</li></ul><h3>4. Expired Links:</h3><ul><li>Once the link expires, users will no longer be able to upload files.</li><li>Extend the expiry time if additional uploads are required by editing the request.</li></ul>', CAST(N'2023-06-02T17:31:21.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2025-01-09T06:24:14.3641046' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'0876e7ef-bf70-4a84-9ef4-ebd36f771390', N'FILE_UPLOAD_REQUEST', N'File Upload Request', N'<h2>File Upload Request</h2><p>The <strong>File Upload Request</strong> feature enables users to upload files securely via a shared link. Users can upload multiple files, provide additional details, and track the status of their submissions.</p><h2>Key Features:</h2><p><strong>1.View File Upload Request Details</strong>:<br>When accessing the upload link, users can see the following details:</p><ul><li><strong>Subject</strong>: The purpose or title of the file request.</li><li><strong>Allowed File Types</strong>: The types of files accepted (e.g., PDF, DOCX, JPG).</li><li><strong>Requested By</strong>: The name or email of the person requesting the files.</li><li><strong>Maximum File Size Upload</strong>: The largest file size allowed for each upload.</li></ul><p><strong>2.Upload Multiple Files</strong>:</p><ul><li>Users can upload multiple files by clicking the <strong>Add Another File</strong> button.</li><li>For each file:<ul><li>Select the file to upload.</li><li>Provide a <strong>File Name</strong> in the accompanying text box to describe the file.</li></ul></li></ul><p><strong>3.Uploaded Files List</strong>:<br>After uploading, users can view a list of their uploaded files, including:</p><ul><li><strong>File Name</strong>: The name of the uploaded file.</li><li><strong>Document Status</strong>: The status of the file (e.g., Pending, Approved, Rejected).</li><li><strong>Uploaded Date</strong>: The date and time the file was uploaded.</li></ul><p><strong>4.Track Document Status</strong>:</p><ul><li>Users can monitor the status of their submissions directly on the upload page:<ul><li><strong>Pending</strong>: Awaiting review by the requester.</li><li><strong>Approved</strong>: File has been accepted.</li><li><strong>Rejected</strong>: File has been rejected with a reason provided.</li></ul></li></ul><h2>How It Works:</h2><h3>1. Accessing the Upload Link:</h3><ul><li>Open the shared upload link provided in the request.</li><li>Review the file request details (e.g., subject, allowed file types, and maximum file size).</li></ul><h3>2. Uploading Files:</h3><ul><li>Click <strong>Add Another File</strong> to upload multiple files.</li><li>For each file:<ol><li>Click the <strong>Choose File</strong> button to select a file from your device.</li><li>Enter a descriptive <strong>File Name</strong> in the text box.</li></ol></li><li>Repeat the process to add additional files.</li><li>Once all files are selected, click <strong>Submit</strong> to upload.</li></ul><h3>3. Viewing Uploaded Files:</h3><ul><li>After submission, the uploaded files will appear in the <strong>Uploaded Files List</strong> below:<ul><li><strong>File Name</strong>: Displays the name entered for each file.</li><li><strong>Document Status</strong>: Shows the current status of the document (e.g., Pending, Approved, Rejected).</li><li><strong>Uploaded Date</strong>: Indicates when the file was submitted.</li></ul></li></ul><h3>4. Tracking and Resubmitting:</h3><ul><li>If a file is rejected, check the <strong>Document Status</strong> for a rejection reason.</li><li>Re-upload the corrected file by clicking <strong>Add Another File</strong> and submitting again.</li></ul><h2>Benefits:</h2><ul><li><strong>Ease of Use</strong>: Users can upload multiple files seamlessly with a clear interface.</li><li><strong>Transparency</strong>: Users can track the status of their submissions in real time.</li><li><strong>Flexibility</strong>: The ability to add descriptive names and upload multiple files ensures better organization.</li></ul><p>This feature makes it easy for users to submit files, manage uploads, and stay informed about the status of their submissions.</p>', CAST(N'2023-06-02T17:31:21.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2025-01-09T06:35:11.5450954' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'0d0a1c72-4e06-4793-923a-3fe1fe1695d5', N'ARCHIVE_DOCUMENTS', N'Archive Documents', N'<h2>Archive Documents</h2><p>The <strong>Archive Documents</strong> feature provides a centralized location to manage, share, and restore archived files. It ensures secure storage and easy access to older documents while offering several actions to organize and use these files effectively.</p><h2>Key Features:</h2><p><strong>1.Get Shareable Link</strong>:</p><ul><li>Generate a unique, shareable link for any archived document.</li><li>Use this link to securely share the document with others.</li></ul><p><strong>2.View Document</strong>:</p><ul><li>Preview the archived document directly without downloading.</li><li>Supports common file types like PDF, DOCX, JPG, and more.</li></ul><p><strong>3.Restore Document</strong>:</p><ul><li>Restore an archived document to its original location or active status.</li><li>This allows you to reinstate files that may be needed again.</li></ul><p><strong>4.Download Document</strong>:</p><ul><li>Download a copy of the archived document to your device.</li><li>Ideal for offline access or sharing outside the system.</li></ul><p><strong>5.Version History</strong>:</p><ul><li>Access the complete version history of the document.</li><li>View changes, updates, or previous versions and restore a specific version if needed.</li></ul><p><strong>6.Delete Document</strong>:</p><ul><li>Permanently remove the archived document from the system.</li><li>Ensure careful use as deleted files cannot be recovered.</li></ul><p><strong>7.Send via Email</strong>:</p><ul><li>Email the archived document directly to one or more recipients.</li><li>Include a personalized message if required.</li></ul><p><strong>8.Filter Data</strong>:</p><ul><li>Quickly find specific documents using advanced filters, such as:<ul><li><strong>Document Name</strong></li><li><strong>Uploaded Date</strong></li><li><strong>Status</strong></li><li><strong>etc.</strong></li></ul></li></ul><h2>How It Works:</h2><h3>1. Accessing Archived Documents:</h3><ul><li>Navigate to the <strong>Archive Documents</strong> page.</li><li>Use the search bar or filters to locate the desired document.</li></ul><h3>2. Managing Documents:</h3><ul><li><strong>Get Shareable Link</strong>:<ul><li>Click on the "Share" icon next to the document.</li><li>Copy the generated link and share it securely.</li></ul></li><li><strong>View Document</strong>:<ul><li>Click on the "View" option to preview the document.</li></ul></li><li><strong>Restore Document</strong>:<ul><li>Select the document and click "Restore" to move it back to its active location.</li></ul></li><li><strong>Download Document</strong>:<ul><li>Click the "Download" button to save a copy of the file to your device.</li></ul></li><li><strong>Version History</strong>:<ul><li>Open the document’s version history to review or restore previous versions.</li></ul></li><li><strong>Delete Document</strong>:<ul><li>Click the "Delete" button to permanently remove the file. Confirm the action if prompted.</li></ul></li><li><strong>Send via Email</strong>:<ul><li>Select the "Send Email" option, enter the recipient’s email address, and send the document with an optional message.</li></ul></li></ul><h3>3. Using Filters:</h3><ul><li>Apply filters like <strong>Document Name</strong>, <strong>Uploaded Date</strong>, or <strong>File Type</strong> to refine the list of archived documents.</li><li>Combine multiple filters for more specific results.</li></ul><h2>Benefits:</h2><ul><li><strong>Efficient Organization</strong>: Keep archived files easily accessible and manageable.</li><li><strong>Flexible Sharing</strong>: Share documents securely with links or via email.</li><li><strong>Version Control</strong>: Maintain a history of document changes for accountability.</li><li><strong>Easy Recovery</strong>: Restore archived files when needed without losing data.</li></ul><p>This functionality ensures a smooth workflow for managing archived documents while maintaining security and flexibility.</p>', CAST(N'2023-06-02T17:31:21.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2025-01-09T10:49:20.7857070' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'3146815f-2d9d-4b9c-963b-ab2dcfa6aa1d', N'REQUEST_DOCUMENT_THROUGH_WORKFLOW', N'Request Document Through Workflow', N'<h3>Request Document through Workflow</h3><p>Requesting a document through a workflow ensures a systematic and organized process. Follow these steps for a smooth experience:</p><p><strong>1.Select Workflow</strong><br>Begin by choosing the appropriate workflow. A workflow is a predefined process designed to handle document requests efficiently.</p><p><strong>2.Request Document Category</strong><br>Specify the category of the document you are requesting. Categories help in organizing and identifying the purpose of the requested document.</p><p><strong>3.Requested Document Name</strong><br>Clearly mention the name of the document you are requesting. This ensures there is no confusion about the specific document required.</p><p><strong>4.Instruction to Upload Document</strong><br>Provide clear and detailed instructions for uploading the document. Include any file format, size limitations, or additional details to make the process seamless.</p>', CAST(N'2023-06-02T17:31:21.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2025-01-10T05:08:32.8088137' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES
(N'9bb0fa5e-5386-4132-9b67-8e83fd0f5acd', N'BULK_DOCUMENT_UPLOADS', N'Bulk Document Uploads', N'<h3><strong>Bulk Document Uploads</strong></h3><p>Easily upload multiple documents to your system with the following steps:</p><p><strong>1.Category</strong></p><ul><li><strong>Select Category</strong>: Choose a category where your documents will be stored. This helps organize your uploads.</li></ul><p><strong>2.Document Status</strong></p><ul><li>Define the status of each document (e.g., Draft, Final, Archived). This ensures clarity and organization.</li></ul><p><strong>3.Storage</strong></p><ul><li>Select the storage location for your documents:<ul><li><strong>Local</strong>: Save documents to the local storage system.</li></ul></li></ul><p><strong>4.Assign By Roles</strong></p><ul><li><strong>5.Roles</strong>: Assign specific roles to the documents. For example: "Manager," "Editor," or "Viewer."</li><li>This determines which roles have access to the uploaded documents.</li></ul><p><strong>6.Assign By Users</strong></p><ul><li><strong>7.Users</strong>: Assign individual users who can access these documents.</li><li>Select from a list of users in your system.</li></ul><p><strong>8.Document Upload</strong></p><ul><li>Select multiple files to upload from your device.</li><li>Ensure the file extensions are in the allowed list.</li><li>Optionally, rename files before uploading to keep them organized.</li></ul><p><strong>9.Finalize Upload</strong></p><ul><li>After filling out all the required fields, upload the documents.</li><li>The system will automatically assign the selected roles and users to each uploaded file.</li></ul>', CAST(N'2023-06-02T17:31:21.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2025-01-15T12:06:27.8643831' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES
(N'8fa4ec82-af7e-4182-b413-d38eb9a55a9a', N'CLIENTS', N'Clients', N'<p>The <strong>Clients</strong> section helps you manage and view all your clients in one place. Here’s what you can do:</p><p><strong>1.Clients List</strong></p><ul><li>A list of all your clients is displayed with the following details:</li></ul><p><strong>Action</strong>: Options to edit or delete client information.</p><p><strong>Company/Person Name</strong>: The name of the company or individual client.</p><p><strong>Contact Person</strong>: The primary contact person for the client.</p><p><strong>Email</strong>: The email address of the client for communication.</p><p><strong>Mobile Number</strong>: The mobile number of the client for easy contact.</p><p><strong>2.Add Client</strong></p><ul><li>Click the <strong>"Add Client"</strong> button to create a new client.</li><li>Fill in details like the company or person name, contact person, email, and mobile number.</li><li>Save the new client, and it will be added to the clients list.</li></ul>', CAST(N'2023-06-02T17:31:21.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2025-01-25T10:55:05.7453776' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES
(N'32688863-5177-4747-8e3d-64edce88c577', N'MANAGE_CLIENT', N'Manage Client', N'<p>The <strong>Manage Client</strong> feature makes it easy to add new clients or edit existing client details. Here’s how you can use it:</p><h4><strong>Add New Client</strong></h4><p>1.Click the <strong>"Add Client"</strong> button.</p><p>2.A form will appear where you can enter the following details:</p><p><strong>Company/Person Name</strong>: Enter the name of the company or individual client.</p><p><strong>Contact Person</strong>: Provide the name of the main contact person.</p><p><strong>Email</strong>: Enter the client’s email address.</p><p><strong>Mobile Number</strong>: Add the client’s mobile number for quick contact.</p><p>3.Once all the details are filled in, click the <strong>"Save"</strong> button to add the new client to the list.</p><p>4.The newly added client will now appear in the <strong>Clients List</strong>.</p><h4><strong>Edit Existing Client</strong></h4><p>1.In the <strong>Clients List</strong>, locate the client whose details you want to edit.</p><p>2.Click the <strong>Edit</strong> button in the <strong>Action</strong> column.</p><p>3.A form will open, pre-filled with the client’s existing details.</p><p>4.Update any necessary fields, such as:</p><p>Correcting the email address or phone number.</p><p>Changing the contact person or company name.</p><p>5.After making the changes, click the <strong>"Save"</strong> button to update the client’s information.</p><p>6.The changes will reflect immediately in the <strong>Clients List</strong>.</p>', CAST(N'2023-06-02T17:31:21.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2025-01-25T10:54:24.7312542' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)


--RoleClaims
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'e305603b-efe3-4488-b3a1-05538636b3f9', N'33c5442e-2844-497c-af00-9cda5a6fc826', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Workflow_Logs_Workflow_Logs', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'bb30ce8b-7997-4050-bdf7-70fcfbdfe072', N'efe7d58a-1c33-4f2a-9b7b-3e1dff6b5664', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Workflows_Workflows', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'd21e68ba-c59e-4b3f-8125-85f0eff382e4', N'a676aa9b-8ccb-4608-8e21-2cdd9a37fd99', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Current_Workflow_Current_Workflow', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'5c578ad3-7603-4ff0-a09b-1e7767c3da0f', N'309f72e8-6e93-43fa-9203-808b030a33f7', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Workflow_Settings_Edit_Workflow_Settings', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'899dab9d-9a22-4f8e-9ce6-31042ef37cf1', N'309f72e8-6e93-43fa-9203-808b030a33f7', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Workflow_Settings_Add_Workflow_Settings', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'4232d0fd-b6e7-4a61-b2f0-f247466cf5b2', N'309f72e8-6e93-43fa-9203-808b030a33f7', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Workflow_Settings_View_Workflow_Settings', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'8bede5b8-debc-47a6-aeab-ff695cf68421', N'309f72e8-6e93-43fa-9203-808b030a33f7', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Workflow_Settings_Delete_Workflow_Settings', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'a441d0f5-84cb-40b1-b1c3-c8c971e68f80', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Assigned_Documents_Add_Signature', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'e14a7417-23cc-4327-892e-f9bf7a3f8c84', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'All_Documents_Start_Workflow', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'e14a7417-23cc-4327-892e-f9bf7a3f8c84', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Assigned_Documents_Start_Workflow', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'b9c0eea9-6d73-4181-89f0-aa060a268e47', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'All_Documents_Manage_Indexing', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'b9c0eea9-6d73-4181-89f0-aa060a268e47', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Assigned_Documents_Manage_Indexing', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'A441D0F5-84CB-40B1-B1C3-C8C971E68F80', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'All_Documents_Add_Signature', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'2EA6BA08-EB36-4E34-92D9-F1984C908B31', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Assigned_Documents_Share_Document', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'A8DD972D-E758-4571-8D39-C6FEC74B361B', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Assigned_Documents_Edit_Document', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'63ED1277-1DB5-4CF7-8404-3E3426CB4BC5', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Assigned_Documents_View_Documents', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'595A769D-F7EF-45F3-9F9E-60C58C5E1542', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Assigned_Documents_Send_Email', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'6719A065-8A4A-4350-8582-BFC41CE283FB', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Assigned_Documents_Download_Document', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'0AAAFAF0-CE63-4055-9204-DB4B03160CDE', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Assigned_Documents_Upload_New_Version', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'E3EBB06C-1D2C-4FA8-A3E8-612ADA02D4AE', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Assigned_Documents_Restore_Version', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'caec2939-374a-4fc9-8659-e4f3c625b602', N'ffee08a0-35e0-485a-a335-e455fb59e344', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'File_Request_Add_File_Request', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'6294cfd8-30b5-4f43-8e2e-1a21d81711b0', N'ffee08a0-35e0-485a-a335-e455fb59e344', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'File_Request_Edit_File_Request', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'dde44280-9105-449b-8cdb-4e575d699a04', N'ffee08a0-35e0-485a-a335-e455fb59e344', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'File_Request_Delete_File_Request', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'78877a7f-55a5-40fb-96e0-9ef9fa5db4d6', N'ffee08a0-35e0-485a-a335-e455fb59e344', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'File_Request_View_File_Request', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'6dfe1243-4464-48ac-8913-8c943c13415e', N'ffee08a0-35e0-485a-a335-e455fb59e344', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'File_Request_Approved_File_Request_Documents', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'3792eac2-d9ef-467e-8a6f-321f20f1b831', N'ffee08a0-35e0-485a-a335-e455fb59e344', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'File_Request_Rejected_File_Request_Documents', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'5b65110d-1ac7-444d-86da-569520f88989', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'All_Documents_Archive_Document', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'5b65110d-1ac7-444d-86da-569520f88989', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Assigned_Documents_Archive_Document', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'F0BD06DA-4E1B-41BC-ABB0-AC833392C880', N'8130904f-4e5b-47d4-8acf-c9cff36d48a4', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Archive_Documents_Create_Shareable_Link', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'6719A065-8A4A-4350-8582-BFC41CE283FB', N'8130904f-4e5b-47d4-8acf-c9cff36d48a4', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Archive_Documents_Download_Document', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'652c4cba-ab06-4345-9795-452088a3fd47', N'8130904f-4e5b-47d4-8acf-c9cff36d48a4', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Archive_Documents_Restore_Document', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'229AD778-C7D3-4F5F-AB52-24B537C39514', N'8130904f-4e5b-47d4-8acf-c9cff36d48a4', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Archive_Documents_Delete_Document', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'1E2453BD-A1CD-4E8F-B5B3-7C536CE7FED5', N'8130904f-4e5b-47d4-8acf-c9cff36d48a4', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Archive_Documents_View_version_history', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'595A769D-F7EF-45F3-9F9E-60C58C5E1542', N'8130904f-4e5b-47d4-8acf-c9cff36d48a4', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Archive_Documents_Send_Email', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'11a649a2-1430-4b1e-9166-eb00bd18c1c4', N'eb342fd3-836f-437c-9b6b-b7e4188fb49c', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Bulk_Document_Uploads_Bulk_Document_Uploads', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'10159009-0d83-46f1-8841-7c3ff2a66f08', N'dc075340-895b-41c0-93da-1767f097a64b', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Clients_View_Clients', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'5c429835-b3b4-4bc1-8c79-aefec27fc18f', N'dc075340-895b-41c0-93da-1767f097a64b', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Clients_Add_Clients', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'5ec34af3-4679-4807-bd21-4560852cd241', N'dc075340-895b-41c0-93da-1767f097a64b', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Clients_Edit_Clients', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'68368c17-7dfc-42c8-96bb-51f1cc8064a6', N'dc075340-895b-41c0-93da-1767f097a64b', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Clients_Delete_Clients', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'1040ef78-4172-4f7e-aff0-16a7818b184a', N'ffee08a0-35e0-485a-a335-e455fb59e344', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Allow_To_See_File_Request', N'')


Update Screens set OrderNo = 6 where name = 'Current Workflow';
Update Screens set OrderNo = 7 where name = 'Workflows';
Update Screens set OrderNo = 8 where name = 'Clients';
Update Screens set OrderNo = 9 where name = 'Workflow Settings';
Update Screens set OrderNo = 10 where name = 'Workflow Logs';
Update Screens set OrderNo = 11 where name = 'Deep Search';
Update Screens set OrderNo = 12 where name = 'Document Status';
Update Screens set OrderNo = 13 where name = 'Document Meta Tags';
Update Screens set OrderNo = 14 where name = 'Document Category';
Update Screens set OrderNo = 15 where name = 'Document Audit Trail';
Update Screens set OrderNo = 16 where name = 'Archive Documents';
Update Screens set OrderNo = 17 where name = 'Role';
Update Screens set OrderNo = 18 where name = 'User';
Update Screens set OrderNo = 19 where name = 'Reminder';
Update Screens set OrderNo = 20 where name = 'Storage Settings';
Update Screens set OrderNo = 21 where name = 'Company Profile';
Update Screens set OrderNo = 22 where name = 'Email';
Update Screens set OrderNo = 23 where name = 'Login Audit';
Update Screens set OrderNo = 24 where name = 'Page Helper';
Update Screens set OrderNo = 25 where name = 'Error Logs';


--AllowFileExtensions
INSERT [dbo].[AllowFileExtensions] ([Id], [Extension], [FileType]) VALUES 
(N'64dac07d-9072-4661-b537-053a09d42d6e', N'doc,docx,ppt,pptx,xls,xlsx', 0)
INSERT [dbo].[AllowFileExtensions] ([Id], [Extension], [FileType]) VALUES 
(N'0c0be0a9-0a4e-4f05-8742-3a5d6d74acf0', N'png,jpg,jpeg,gif,bmp,svg,webp,ico,avif', 2)
INSERT [dbo].[AllowFileExtensions] ([Id], [Extension], [FileType]) VALUES
(N'cb1612ef-8e3c-4823-af2b-469f4b0010b8', N'webm,ogv,mp4', 5)
INSERT [dbo].[AllowFileExtensions] ([Id], [Extension], [FileType]) VALUES
(N'ab5db62f-1fc7-49ed-895f-6ac4be6db33a', N'zip,7z', 6)
INSERT [dbo].[AllowFileExtensions] ([Id], [Extension], [FileType]) VALUES 
(N'9eaf6b33-0cef-45a4-bf92-7c525e2ed536', N'aac,m4a,mp3,ogg,oga,wav', 4)
INSERT [dbo].[AllowFileExtensions] ([Id], [Extension], [FileType]) VALUES 
(N'13a28d05-d6be-4e6b-87fe-b784642e2a95', N'txt', 3)
INSERT [dbo].[AllowFileExtensions] ([Id], [Extension], [FileType]) VALUES 
(N'3257c50c-a128-4c98-8809-cc2564b7db2a', N'pdf', 1)
INSERT [dbo].[AllowFileExtensions] ([Id], [Extension], [FileType]) VALUES 
(N'D26F0953-14AC-4138-BBB8-94B230FBF5F3', N'csv', 7)
INSERT [dbo].[AllowFileExtensions] ([Id], [Extension], [FileType]) VALUES 
(N'0AC7C26C-7308-47A3-B11D-E7D3D220F690', N'json', 8)

GO


--GetPendingWorkflowTransitions stored procedure
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[GetPendingWorkflowTransitions]
    @CurrentStepId uniqueidentifier -- Input parameter for the starting step
AS
BEGIN
    -- Use a Common Table Expression (CTE) for recursive query
    WITH TransitionPaths AS (
        -- Base case: Start from the current step
        SELECT 
            WT.id AS TransitionId,
            WT.FromStepId,
            WT.ToStepId,
         	WT.Name AS TransitionName,
            CAST(WT.FromStepId AS VARCHAR(MAX)) + '->' + CAST(WT.ToStepId AS VARCHAR(MAX)) AS transition_path,
            1 AS depth -- Track recursion depth
        FROM WorkflowTransitions WT
        JOIN WorkflowSteps WS_from ON WT.FromStepId = WS_from.id
        JOIN WorkflowSteps WS_to ON WT.ToStepId = WS_to.id
        WHERE WT.FromStepId = @CurrentStepId

        UNION ALL

        -- Recursive case: Find transitions from the current step's ToStepId
        SELECT 
            WT.id AS TransitionId,
            WT.FromStepId,
            WT.ToStepId,
         	WT.Name As TransitionName,
            CAST(TP.transition_path + ',' + CAST(WT.FromStepId AS VARCHAR(MAX)) + '->' + CAST(WT.ToStepId AS VARCHAR(MAX)) AS VARCHAR(MAX)) AS transition_path,
            TP.depth + 1 AS depth -- Increment depth for recursion tracking
        FROM WorkflowTransitions WT
        JOIN WorkflowSteps WS_from ON WT.FromStepId = WS_from.id
        JOIN WorkflowSteps WS_to ON WT.ToStepId = WS_to.id
        JOIN TransitionPaths TP ON TP.ToStepId = WT.FromStepId
        WHERE CHARINDEX(CAST(WT.FromStepId AS VARCHAR(MAX)) + '->' + CAST(WT.ToStepId AS VARCHAR(MAX)), TP.transition_path) = 0 -- Include unique transitions
              OR TP.depth = 1 -- Allow circular transitions once at depth 1
    )
    -- Select distinct transitions and ensure valid paths
    SELECT DISTINCT
        TransitionId,
        FromStepId,
        ToStepId,
		TransitionName
    FROM TransitionPaths
  
    ORDER BY TransitionId;
END;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250214054551_Version_V5_Data', N'8.0.13');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

DROP INDEX [IX_Documents_Url] ON [Documents];
GO

DECLARE @var20 sysname;
SELECT @var20 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Documents]') AND [c].[name] = N'DocumentNumber');
IF @var20 IS NOT NULL EXEC(N'ALTER TABLE [Documents] DROP CONSTRAINT [' + @var20 + '];');
ALTER TABLE [Documents] DROP COLUMN [DocumentNumber];
GO

ALTER TABLE [DocumentVersions] ADD [Extension] nvarchar(max) NULL;
GO

ALTER TABLE [DocumentVersions] ADD [IsAllChunkUploaded] bit NOT NULL DEFAULT CAST(0 AS bit);
GO

ALTER TABLE [DocumentVersions] ADD [IsChunk] bit NOT NULL DEFAULT CAST(0 AS bit);
GO

ALTER TABLE [DocumentVersions] ADD [IsCurrentVersion] bit NOT NULL DEFAULT CAST(0 AS bit);
GO

ALTER TABLE [DocumentVersions] ADD [VersionNumber] int NOT NULL DEFAULT 0;
GO

DECLARE @var21 sysname;
SELECT @var21 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Documents]') AND [c].[name] = N'Url');
IF @var21 IS NOT NULL EXEC(N'ALTER TABLE [Documents] DROP CONSTRAINT [' + @var21 + '];');
ALTER TABLE [Documents] ALTER COLUMN [Url] nvarchar(max) NULL;
GO

ALTER TABLE [Documents] ADD [Extension] nvarchar(max) NULL;
GO

ALTER TABLE [Documents] ADD [IsAllChunkUploaded] bit NOT NULL DEFAULT CAST(0 AS bit);
GO

ALTER TABLE [Documents] ADD [IsChunk] bit NOT NULL DEFAULT CAST(0 AS bit);
GO

CREATE TABLE [DocumentChunk] (
    [Id] uniqueidentifier NOT NULL,
    [ChunkIndex] int NOT NULL,
    [Url] nvarchar(max) NULL,
    [Size] bigint NOT NULL,
    [Extension] nvarchar(max) NULL,
    [DocumentVersionId] uniqueidentifier NOT NULL,
    CONSTRAINT [PK_DocumentChunk] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_DocumentChunk_DocumentVersions_DocumentVersionId] FOREIGN KEY ([DocumentVersionId]) REFERENCES [DocumentVersions] ([Id]) ON DELETE CASCADE
);
GO

CREATE INDEX [IX_DocumentChunk_DocumentVersionId] ON [DocumentChunk] ([DocumentVersionId]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250224063537_drop_doc_number', N'8.0.13');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

ALTER TABLE [DocumentChunk] DROP CONSTRAINT [FK_DocumentChunk_DocumentVersions_DocumentVersionId];
GO

ALTER TABLE [DocumentIndexes] DROP CONSTRAINT [FK_DocumentIndexes_Documents_DocumentId];
GO

ALTER TABLE [DocumentChunk] DROP CONSTRAINT [PK_DocumentChunk];
GO

EXEC sp_rename N'[DocumentChunk]', N'DocumentChunks';
GO

EXEC sp_rename N'[DocumentIndexes].[DocumentId]', N'DocumentVersionId', N'COLUMN';
GO

EXEC sp_rename N'[DocumentIndexes].[IX_DocumentIndexes_DocumentId]', N'IX_DocumentIndexes_DocumentVersionId', N'INDEX';
GO

EXEC sp_rename N'[DocumentChunks].[IX_DocumentChunk_DocumentVersionId]', N'IX_DocumentChunks_DocumentVersionId', N'INDEX';
GO

ALTER TABLE [Users] ADD [ClientId] nvarchar(max) NULL;
GO

ALTER TABLE [Users] ADD [ClientSecretHash] nvarchar(max) NULL;
GO

ALTER TABLE [UserNotifications] ADD [CategoryId] uniqueidentifier NULL;
GO

DECLARE @var22 sysname;
SELECT @var22 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Documents]') AND [c].[name] = N'Name');
IF @var22 IS NOT NULL EXEC(N'ALTER TABLE [Documents] DROP CONSTRAINT [' + @var22 + '];');
ALTER TABLE [Documents] ALTER COLUMN [Name] nvarchar(450) NULL;
GO

ALTER TABLE [Documents] ADD [DocumentNumber] nvarchar(max) NULL;
GO

ALTER TABLE [DocumentMetaDatas] ADD [DocumentMetaTagId] uniqueidentifier NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000';
GO

ALTER TABLE [DocumentMetaDatas] ADD [MetaTagDate] datetime2 NULL;
GO

DECLARE @var23 sysname;
SELECT @var23 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[DocumentAuditTrails]') AND [c].[name] = N'DocumentId');
IF @var23 IS NOT NULL EXEC(N'ALTER TABLE [DocumentAuditTrails] DROP CONSTRAINT [' + @var23 + '];');
ALTER TABLE [DocumentAuditTrails] ALTER COLUMN [DocumentId] uniqueidentifier NULL;
GO

ALTER TABLE [DocumentAuditTrails] ADD [CategoryId] uniqueidentifier NULL;
GO

ALTER TABLE [CustomCategories] ADD [IsArchive] bit NOT NULL DEFAULT CAST(0 AS bit);
GO

DECLARE @var24 sysname;
SELECT @var24 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Categories]') AND [c].[name] = N'Name');
IF @var24 IS NOT NULL EXEC(N'ALTER TABLE [Categories] DROP CONSTRAINT [' + @var24 + '];');
ALTER TABLE [Categories] ALTER COLUMN [Name] nvarchar(450) NULL;
GO

ALTER TABLE [Categories] ADD [ArchiveParentId] uniqueidentifier NULL;
GO

ALTER TABLE [Categories] ADD [IsArchive] bit NOT NULL DEFAULT CAST(0 AS bit);
GO

ALTER TABLE [DocumentChunks] ADD [TotalChunk] int NOT NULL DEFAULT 0;
GO

ALTER TABLE [DocumentChunks] ADD CONSTRAINT [PK_DocumentChunks] PRIMARY KEY ([Id]);
GO

CREATE TABLE [CategoryRolePermissions] (
    [Id] uniqueidentifier NOT NULL,
    [CategoryId] uniqueidentifier NOT NULL,
    [RoleId] uniqueidentifier NOT NULL,
    [StartDate] datetime2 NULL,
    [EndDate] datetime2 NULL,
    [IsTimeBound] bit NOT NULL,
    [IsAllowDownload] bit NOT NULL,
    [ParentId] uniqueidentifier NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [ModifiedDate] datetime2 NOT NULL,
    [ModifiedBy] uniqueidentifier NOT NULL,
    [DeletedDate] datetime2 NULL,
    [DeletedBy] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_CategoryRolePermissions] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_CategoryRolePermissions_Categories_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [Categories] ([Id]),
    CONSTRAINT [FK_CategoryRolePermissions_Roles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [Roles] ([Id]),
    CONSTRAINT [FK_CategoryRolePermissions_Users_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [Users] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [CategoryUserPermissions] (
    [Id] uniqueidentifier NOT NULL,
    [CategoryId] uniqueidentifier NOT NULL,
    [UserId] uniqueidentifier NOT NULL,
    [StartDate] datetime2 NULL,
    [EndDate] datetime2 NULL,
    [IsTimeBound] bit NOT NULL,
    [IsAllowDownload] bit NOT NULL,
    [ParentId] uniqueidentifier NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [ModifiedDate] datetime2 NOT NULL,
    [ModifiedBy] uniqueidentifier NOT NULL,
    [DeletedDate] datetime2 NULL,
    [DeletedBy] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_CategoryUserPermissions] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_CategoryUserPermissions_Categories_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [Categories] ([Id]),
    CONSTRAINT [FK_CategoryUserPermissions_Users_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [Users] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_CategoryUserPermissions_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id])
);
GO

CREATE TABLE [DocumentMetaTags] (
    [Id] uniqueidentifier NOT NULL,
    [Type] int NOT NULL,
    [Name] nvarchar(max) NULL,
    [IsEditable] bit NOT NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [ModifiedDate] datetime2 NOT NULL,
    [ModifiedBy] uniqueidentifier NOT NULL,
    [DeletedDate] datetime2 NULL,
    [DeletedBy] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_DocumentMetaTags] PRIMARY KEY ([Id])
);
GO

CREATE INDEX [IX_UserNotifications_CategoryId] ON [UserNotifications] ([CategoryId]);
GO

CREATE UNIQUE INDEX [IX_Documents_Name_CategoryId_IsArchive_IsDeleted] ON [Documents] ([Name], [CategoryId], [IsArchive], [IsDeleted]) WHERE [Name] IS NOT NULL;
GO

CREATE INDEX [IX_DocumentMetaDatas_DocumentMetaTagId] ON [DocumentMetaDatas] ([DocumentMetaTagId]);
GO

CREATE INDEX [IX_DocumentAuditTrails_CategoryId] ON [DocumentAuditTrails] ([CategoryId]);
GO

CREATE INDEX [IX_Categories_CreatedBy] ON [Categories] ([CreatedBy]);
GO

CREATE INDEX [IX_Categories_Name_ParentId_IsArchive_IsDeleted] ON [Categories] ([Name], [ParentId], [IsArchive], [IsDeleted]);
GO

CREATE INDEX [IX_CategoryRolePermissions_CategoryId] ON [CategoryRolePermissions] ([CategoryId]);
GO

CREATE INDEX [IX_CategoryRolePermissions_CreatedBy] ON [CategoryRolePermissions] ([CreatedBy]);
GO

CREATE INDEX [IX_CategoryRolePermissions_RoleId] ON [CategoryRolePermissions] ([RoleId]);
GO

CREATE INDEX [IX_CategoryUserPermissions_CategoryId] ON [CategoryUserPermissions] ([CategoryId]);
GO

CREATE INDEX [IX_CategoryUserPermissions_CreatedBy] ON [CategoryUserPermissions] ([CreatedBy]);
GO

CREATE INDEX [IX_CategoryUserPermissions_UserId] ON [CategoryUserPermissions] ([UserId]);
GO

ALTER TABLE [Categories] ADD CONSTRAINT [FK_Categories_Users_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [Users] ([Id]);
GO

ALTER TABLE [DocumentAuditTrails] ADD CONSTRAINT [FK_DocumentAuditTrails_Categories_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [Categories] ([Id]);
GO

ALTER TABLE [DocumentChunks] ADD CONSTRAINT [FK_DocumentChunks_DocumentVersions_DocumentVersionId] FOREIGN KEY ([DocumentVersionId]) REFERENCES [DocumentVersions] ([Id]) ON DELETE CASCADE;
GO

ALTER TABLE [DocumentIndexes] ADD CONSTRAINT [FK_DocumentIndexes_DocumentVersions_DocumentVersionId] FOREIGN KEY ([DocumentVersionId]) REFERENCES [DocumentVersions] ([Id]) ON DELETE CASCADE;
GO

ALTER TABLE [DocumentMetaDatas] ADD CONSTRAINT [FK_DocumentMetaDatas_DocumentMetaTags_DocumentMetaTagId] FOREIGN KEY ([DocumentMetaTagId]) REFERENCES [DocumentMetaTags] ([Id]);
GO

ALTER TABLE [UserNotifications] ADD CONSTRAINT [FK_UserNotifications_Categories_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [Categories] ([Id]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250402120528_Version_V6', N'8.0.13');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted], [OrderNo]) VALUES 
(N'a51a1261-aa38-4c07-a513-38c8e619d141', N'Document Meta Tags', CAST(N'2024-12-23T06:59:21.6608642' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T06:59:21.6666667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0, NULL)
INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted], [OrderNo]) VALUES 
(N'da660d2d-450b-4825-9489-d87ef94ad6ff', N'Assigned Folders', CAST(N'2024-12-23T06:59:21.6608642' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T06:59:21.6666667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0, NULL)
INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted], [OrderNo]) VALUES 
(N'b6058070-8cca-4bc0-a88a-5596cbd63683', N'All Folders', CAST(N'2024-12-23T06:59:21.6608642' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T06:59:21.6666667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0, NULL)
INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted], [OrderNo]) VALUES 
(N'2502e117-1752-4c6f-8fdb-cb32cb4c1e59', N'Archive Folders', CAST(N'2024-12-23T06:59:21.6608642' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T06:59:21.6666667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0, NULL)
INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted], [OrderNo]) VALUES 
(N'f4a940bd-8f81-4b5c-abd1-0ddb8083c4da', N'OCR Content Extractor', CAST(N'2024-12-23T06:59:21.6608642' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T06:59:21.6666667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0, NULL)
INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted], [OrderNo]) VALUES 
(N'c6d248e0-f702-4334-b0b8-0c403a82715f', N'Allow File Extensions', CAST(N'2024-12-23T06:59:21.6608642' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T06:59:21.6666667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0, NULL)

INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'2f5137b5-1e40-49eb-9484-98c1bd2fb8d6', N'Share Folder', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'11cac831-b1d4-486e-9db9-f28a72eec7b4', N'Remove Share Document', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'5199d10d-8347-4c2d-84b2-39760bb1a353', N'Remove Share Folder', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'7912a5c0-7823-4fb0-8c33-93535272763f', N'View Document Meta Tags', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'116eede3-6b4a-412b-a236-9ddca96bb61c', N'Edit Document Meta Tags', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'8baac1c6-29cb-4592-9be4-67df470eed8d', N'Add Document Meta Tags', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'a4476d4a-781f-4e70-9a52-bb42b5be386c', N'Delete Document Meta Tags', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'775118ca-001c-4010-86aa-e62066ccf4ff', N'Restore Folder', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'a216a13e-4717-4fc2-9aaf-eef929257e9b', N'OCR Content Extractor', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'938e1ccf-e635-47f1-9dcf-db9632841438', N'Add Allow File Extensions', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'04fab107-0672-48c2-8d68-8ec538721047', N'Edit Allow File Extensions', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'f219daef-9fa4-489a-86dd-769ae461c938', N'View Allow File Extensions', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'5339f0e1-5df3-40a9-85d9-eab621cdb8a7', N'Delete Allow File Extensions', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'6a22edba-5234-4b2f-87da-dd9d18dc9d02', N'Get Document Summary', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)


INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'44195689-7037-4bce-9e5f-b7de96c4fba8', N'5199d10d-8347-4c2d-84b2-39760bb1a353', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'd40e679d-a08a-4dde-bca8-e75ebfdbd817', N'5199d10d-8347-4c2d-84b2-39760bb1a353', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'd2ae9a3b-a491-4a07-b155-6401ef11712a', N'11cac831-b1d4-486e-9db9-f28a72eec7b4', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'aa12fe9c-3388-429c-90f8-070fb01d5868', N'11cac831-b1d4-486e-9db9-f28a72eec7b4', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'5f3963ab-ceb2-443e-94b6-9ef0752a2d2e', N'7912a5c0-7823-4fb0-8c33-93535272763f', N'a51a1261-aa38-4c07-a513-38c8e619d141', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'4cd7059f-53b5-4ec2-be6b-78cdab96eb70', N'116eede3-6b4a-412b-a236-9ddca96bb61c', N'a51a1261-aa38-4c07-a513-38c8e619d141', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'80071200-5e95-4b91-9334-c1d80a2c9b46', N'8baac1c6-29cb-4592-9be4-67df470eed8d', N'a51a1261-aa38-4c07-a513-38c8e619d141', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'35b754c5-0e48-4788-a71c-4de13a8fe449', N'a4476d4a-781f-4e70-9a52-bb42b5be386c', N'a51a1261-aa38-4c07-a513-38c8e619d141', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'ffa7871f-de6f-4265-9548-4177e2bf5dfe', N'2f5137b5-1e40-49eb-9484-98c1bd2fb8d6', N'da660d2d-450b-4825-9489-d87ef94ad6ff', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'b1375795-6655-47fc-be67-5569a2fe2517', N'd8f12d11-aa74-49b1-9bce-f945517bffde', N'da660d2d-450b-4825-9489-d87ef94ad6ff', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'c2b9abde-bf77-4887-b18e-4a84d24699de', N'2f5137b5-1e40-49eb-9484-98c1bd2fb8d6', N'b6058070-8cca-4bc0-a88a-5596cbd63683', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'c3768706-4767-472e-9bbf-0c515bec6ff4', N'd8f12d11-aa74-49b1-9bce-f945517bffde', N'b6058070-8cca-4bc0-a88a-5596cbd63683', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'df42ffb1-f957-4c63-b07a-c57b1f915ff2', N'775118ca-001c-4010-86aa-e62066ccf4ff', N'2502e117-1752-4c6f-8fdb-cb32cb4c1e59', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'724b0bb9-d15f-4ad6-bf43-a76b1a393bf6', N'9c0e2186-06a4-4207-acbc-f6d8efa430b3', N'2502e117-1752-4c6f-8fdb-cb32cb4c1e59', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'3b11f492-781a-4640-86ec-4382bc46d7d0', N'a216a13e-4717-4fc2-9aaf-eef929257e9b', N'f4a940bd-8f81-4b5c-abd1-0ddb8083c4da', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'bcd3bbf9-fff5-4ece-b82e-35b130406b25', N'938e1ccf-e635-47f1-9dcf-db9632841438', N'c6d248e0-f702-4334-b0b8-0c403a82715f', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'7b90dcef-ec68-4c75-ab24-c1bf2c365b09', N'04fab107-0672-48c2-8d68-8ec538721047', N'c6d248e0-f702-4334-b0b8-0c403a82715f', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'4b60217a-a360-40d2-8641-d7d336a1a1e4', N'f219daef-9fa4-489a-86dd-769ae461c938', N'c6d248e0-f702-4334-b0b8-0c403a82715f', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'2f4259e3-6f34-4f8d-9189-b71e5efeb8e1', N'5339f0e1-5df3-40a9-85d9-eab621cdb8a7', N'c6d248e0-f702-4334-b0b8-0c403a82715f', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'6fd5cbb9-d1b5-4915-9fa9-ab036a5b26f6', N'6a22edba-5234-4b2f-87da-dd9d18dc9d02', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'fb546f57-ce8a-4a58-8c9e-43955c3ea392', N'6a22edba-5234-4b2f-87da-dd9d18dc9d02', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)


INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES
(N'23b67895-da17-44e6-8546-75f39f25a02e', N'ASSIGN_DOCUMENTS_FOLDER_VIEW', N'Documents Folder View', N'<p>The "Documents - Folder View" is designed to provide users with an organized and efficient way to manage document folders assigned to them. In addition to managing individual documents, users can now share entire folders with other users or roles, making collaboration seamless.</p><h3><strong>Add Folder Button</strong></h3><ul><li>Users can create new folders to better categorize and manage their assigned documents.</li><li>Clicking the "Add Folder" button opens a form or pop-up where users can specify the folder name and optional details.</li><li>Users can then upload or move documents into the newly created folder.</li></ul><h2><strong>Folder Management &amp; Actions</strong></h2><p>Each folder in the "Assigned Documents - Folder View" is listed with relevant details, such as:</p><p><strong>Folder Name</strong></p><p><strong>Doc Number</strong></p><p><strong>Created By</strong></p><p><strong>Creation Date</strong></p><p><strong>Action</strong></p><h3><strong>Available Actions for Each Folder</strong></h3><h4><strong>Share Folder</strong></h4><ul><li>Users can share an entire folder with other users or roles, similar to document sharing.</li><li>Permissions can be set for each recipient, such as:<ul><li><strong>View Only:</strong> Users can view documents but not edit or download them.</li><li><strong>Edit:</strong> Users can modify documents within the shared folder.</li><li><strong>Upload New Versions:</strong> Users can upload updated versions of documents.</li><li><strong>Full Access:</strong> Users can manage the folder and its documents entirely.</li></ul></li><li>Shared folders appear in the recipient’s assigned folder list, with access restrictions based on permissions.</li></ul><h2><strong>How to Share a Folder</strong></h2><ol><li>Click the <strong>"Share"</strong> option next to the folder.</li><li>A pop-up window will appear to enter user names, roles, or email addresses.</li><li>Set specific permissions for each user or role.</li><li>Click <strong>"Share"</strong> to finalize the action.</li><li>The recipients will receive a notification and gain access to the shared folder based on the assigned permissions.</li><li>Shared folders function similarly to shared documents, with users having controlled access based on the granted permissions.</li></ol><h2><strong>Folder View - Document Actions</strong></h2><p>Inside each folder, users can view and manage assigned documents. Actions available for documents inside folders include:</p><ul><li><strong>Edit</strong>: Modify document details.</li><li><strong>Share</strong>: Share the document individually with users or roles.</li><li><strong>View</strong>: Open the document in a viewer.</li><li><strong>Upload a Version</strong>: Add an updated version of the document.</li><li><strong>Version History</strong>: View and manage previous versions.</li><li><strong>Comment</strong>: Add or view discussions on the document.</li><li><strong>Add Reminder</strong>: Set a reminder for an event related to the document.</li></ul><p>&nbsp;</p><p>The <strong>Documents - Folder View</strong> enhances document management by introducing folder-based organization and streamlined sharing capabilities, ensuring a more efficient workflow for users.</p><p>&nbsp;</p>', CAST(N'2023-06-02T17:31:21.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2025-03-24T06:34:32.1702855' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES
(N'c30fcf6b-9cd2-4536-ad93-90887f96a0ba', N'DOCUMENT_META_TAGS', N'Document Meta Tags Overview', N'<p>The <strong>Document Meta Tags</strong> feature allows users to manage custom metadata for documents.</p><h4><strong>Features:</strong></h4><p>✅ <strong>Add Meta Tags</strong>: Users can create new meta tags with a type, name, and editability option.<br>✅ <strong>List Meta Tags</strong>: Displays existing meta tags in a table format.<br>✅ <strong>Edit Meta Tags</strong>: Users can modify tags only if the "Is Editable" option is enabled.<br>✅ <strong>Delete Meta Tags</strong>: Users can remove any meta tag from the list.</p><h4><strong>Fields in the Meta Tag Table:</strong></h4><ul><li><strong>Action</strong>: Edit/Delete options (Edit allowed only if editable).</li><li><strong>Type</strong>: Defines the meta tag type (e.g., Text, Date, Number).</li><li><strong>Name</strong>: The name of the meta tag.</li><li><strong>Is Editable</strong>: Indicates whether the tag can be modified.</li></ul>', CAST(N'2023-06-02T17:31:21.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2025-03-25T05:28:29.2394159' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES
(N'a574a57c-f528-4a52-b5d5-a1a0c4e5ada1', N'MANAGE_DOCUMENT_META_TAG', N'Manage Document Meta Tags', N'<p>Users can <strong>add, edit, and manage</strong> document meta tags to customize metadata for documents.</p><h4><strong>Features:</strong></h4><p>✅ <strong>Add Meta Tags</strong>: Users can create new meta tags by specifying:</p><ul><li><strong>Type</strong> (e.g., Text, Date, Number)</li><li><strong>Name</strong> (Custom field name)</li><li><strong>Is Editable</strong> (Allows modification if enabled)</li></ul><p>✅ <strong>Edit Meta Tags</strong>: Users can update the <strong>Type</strong> and <strong>Name</strong> if the tag is marked as <strong>Editable</strong>.</p><p>✅ <strong>Manage Meta Tags</strong>: A structured table displays existing meta tags with options to edit (if allowed) or remove them.</p>', CAST(N'2023-06-02T17:31:21.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2025-03-25T05:30:32.8011672' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES
(N'c56481fa-3975-413b-81cb-3145a6f2fd22', N'OCR_CONTENT_EXTRACTOR', N'OCR Content Extractor', N'<p>The <strong>OCR Content Extractor</strong> allows users to <strong>upload files</strong> and extract text from images or scanned documents.</p><h4><strong>Features:</strong></h4><p>✅ <strong>Upload Files</strong>: Supports image and document formats (e.g., JPG, PNG, PDF).<br>✅ <strong>Extract Text</strong>: Automatically reads and converts text from uploaded files.<br>✅ <strong>Supported Languages</strong>:</p><ul><li><strong>English (ENG)</strong></li><li><strong>French (FRA)</strong></li><li><strong>Spanish (SPA)</strong></li><li><strong>Arabic (ARA)</strong></li><li><strong>Turkish (TUR)</strong></li><li><strong>Polish (POL)</strong></li><li><strong>Nepali (NEP)</strong></li><li><strong>Hindi (HIN)</strong></li></ul><p>Users can easily extract and manage text from documents in multiple languages.</p>', CAST(N'2023-06-02T17:31:21.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2025-03-25T05:30:32.8011672' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES
(N'1232317d-0d32-43bd-97b9-14c5963fd309', N'ARCHIVE_FOLDERS', N'Archive Folders', N'<p>The <strong>Archive Folders</strong> feature provides a centralized location to manage, share, and restore archived folders. It ensures secure storage and easy access to older folders while offering several actions to organize and use these folders effectively.</p><h3><strong>Key Features:</strong></h3><p><strong>Restore Folder:</strong></p><ul><li>Restore an archived folder to its original location or active status.</li><li>All documents inside the folder will also be restored.</li></ul><p><strong>Delete Folder:</strong></p><ul><li>Permanently remove the archived folder from the system.</li><li>Ensure careful use as deleted folders cannot be recovered.</li><li>&nbsp;</li><li><h3><strong>How It Works:</strong></h3></li><li><h4><strong>1. Accessing Archived Folders:</strong></h4></li><li>Navigate to the <strong>Archive Folders</strong> page.</li><li>Use the search bar or filters to locate the desired folder.</li><li><h4><strong>2. Managing Folders:</strong></h4></li><li>✅ <strong>Restore Folder:</strong></li><li>Select the folder and click <strong>\"Restore\"</strong> to move it back to its active location.</li><li>All documents inside the folder will also be reinstated.</li><li>✅ <strong>Delete Folder:</strong></li><li>Click the \"Delete\" button to permanently remove the folder. Confirm the action if prompted.</li><li><h4><strong>3. Using Filters:</strong></h4></li><li>Apply filters like <strong>Folder Name, Created Date, or Owner</strong> to refine the list of archived folders.</li><li>Combine multiple filters for more specific results.</li><li><h3><strong>Benefits:</strong></h3></li><li>✔ <strong>Efficient Organization:</strong> Keep archived folders easily accessible and manageable.<br>✔ <strong>Flexible Sharing:</strong> Share folders securely with links or via email.<br>✔ <strong>Version Control:</strong> Maintain a history of folder changes for accountability.<br>✔ <strong>Easy Recovery:</strong> Restore archived folders when needed without losing data.</li><li>This functionality ensures a smooth workflow for managing archived folders while maintaining security and flexibility.</li></ul>', CAST(N'2023-06-02T17:31:21.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2025-03-25T05:30:32.8011672' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT INTO [dbo].[PageHelpers] 
([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
VALUES
(N'0b8a7053-40e6-4919-94fe-30f66698a8be', 
 N'DOCUMENT_SUMMARY', 
 N'Get Document Summary using ChatGPT', 
 N'<p>The <strong>"Get Document Summary"</strong> functionality allows users to upload a document and generate a concise summary using ChatGPT. 
    This feature helps users quickly understand the document''s content without reading the entire text. 
    Below is a step-by-step guide on how this functionality works and how to configure it.</p>

    <h2>How It Works</h2>
    <ul>
        <li><strong>Upload Document:</strong> The user selects and uploads a document (PDF, Word, or text file).</li>
        <li><strong>Extract Text from Document:</strong> The system extracts the text content from the uploaded document.</li>
        <li><strong>Send Text to ChatGPT API:</strong> The extracted text is sent to OpenAI''s ChatGPT API for summarization.</li>
        <li><strong>Receive Summary Response:</strong> ChatGPT processes the text and returns a summarized version.</li>
        <li><strong>Display Summary to User:</strong> The generated summary is shown on the UI for easy reading.</li>
    </ul>
', 
 CAST(N'2023-06-02T17:31:21.0000000' AS DateTime2), 
 N'4b352b37-332a-40c6-ab05-e38fcf109719', 
 CAST(N'2025-03-25T05:30:32.8011672' AS DateTime2), 
 N'4b352b37-332a-40c6-ab05-e38fcf109719', 
 NULL, NULL, 0);


INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'5199d10d-8347-4c2d-84b2-39760bb1a353', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Assigned_Documents_Remove_Share_Folder', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'5199d10d-8347-4c2d-84b2-39760bb1a353', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'All_Documents_Remove_Share_Folder', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'11cac831-b1d4-486e-9db9-f28a72eec7b4', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Assigned_Documents_Remove_Share_Document', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'11cac831-b1d4-486e-9db9-f28a72eec7b4', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'All_Documents_Remove_Share_Document', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'7912a5c0-7823-4fb0-8c33-93535272763f', N'a51a1261-aa38-4c07-a513-38c8e619d141', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Document_Meta_Tags_View_Document_Meta_Tags', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'116eede3-6b4a-412b-a236-9ddca96bb61c', N'a51a1261-aa38-4c07-a513-38c8e619d141', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Document_Meta_Tags_Edit_Document_Meta_Tags', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'8baac1c6-29cb-4592-9be4-67df470eed8d', N'a51a1261-aa38-4c07-a513-38c8e619d141', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Document_Meta_Tags_Add_Document_Meta_Tags', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'a4476d4a-781f-4e70-9a52-bb42b5be386c', N'a51a1261-aa38-4c07-a513-38c8e619d141', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Document_Meta_Tags_Delete_Document_Meta_Tags', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'2f5137b5-1e40-49eb-9484-98c1bd2fb8d6', N'da660d2d-450b-4825-9489-d87ef94ad6ff', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Assigned_Folders_Share_Folder', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'd8f12d11-aa74-49b1-9bce-f945517bffde', N'da660d2d-450b-4825-9489-d87ef94ad6ff', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Assigned_Folders_Archive_Folder', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'2f5137b5-1e40-49eb-9484-98c1bd2fb8d6', N'b6058070-8cca-4bc0-a88a-5596cbd63683', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'All_Folders_Share_Folder', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'd8f12d11-aa74-49b1-9bce-f945517bffde', N'b6058070-8cca-4bc0-a88a-5596cbd63683', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'All_Folders_Archive_Folder', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'775118ca-001c-4010-86aa-e62066ccf4ff', N'2502e117-1752-4c6f-8fdb-cb32cb4c1e59', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Archive_Folders_Restore_Folder', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'9c0e2186-06a4-4207-acbc-f6d8efa430b3', N'2502e117-1752-4c6f-8fdb-cb32cb4c1e59', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Archive_Folders_Delete_Category', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'a216a13e-4717-4fc2-9aaf-eef929257e9b', N'f4a940bd-8f81-4b5c-abd1-0ddb8083c4da', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'OCR_Content_Extractor_OCR_Content_Extractor', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'938e1ccf-e635-47f1-9dcf-db9632841438', N'c6d248e0-f702-4334-b0b8-0c403a82715f', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Allow_File_Extensions_Add_Allow_File_Extensions', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'04fab107-0672-48c2-8d68-8ec538721047', N'c6d248e0-f702-4334-b0b8-0c403a82715f', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Allow_File_Extensions_Edit_Allow_File_Extensions', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'f219daef-9fa4-489a-86dd-769ae461c938', N'c6d248e0-f702-4334-b0b8-0c403a82715f', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Allow_File_Extensions_View_Allow_File_Extensions', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'5339f0e1-5df3-40a9-85d9-eab621cdb8a7', N'c6d248e0-f702-4334-b0b8-0c403a82715f', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Allow_File_Extensions_Delete_Allow_File_Extensions', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'6a22edba-5234-4b2f-87da-dd9d18dc9d02', N'eddf9e8e-0c70-4cde-b5f9-117a879747d6', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'All_Documents_Get_Document_Summary', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'6a22edba-5234-4b2f-87da-dd9d18dc9d02', N'fc97dc8f-b4da-46b1-a179-ab206d8b7efd', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Assigned_Documents_Get_Document_Summary', N'')


Update Screens set OrderNo = 6 where name = 'Assigned Folders';
Update Screens set OrderNo = 7 where name = 'All Folders';
Update Screens set OrderNo = 8 where name = 'Current Workflow';
Update Screens set OrderNo = 9 where name = 'Workflows';
Update Screens set OrderNo = 10 where name = 'Clients';
Update Screens set OrderNo = 11 where name = 'Workflow Settings';
Update Screens set OrderNo = 12 where name = 'Workflow Logs';
Update Screens set OrderNo = 13 where name = 'Deep Search';
Update Screens set OrderNo = 14 where name = 'OCR Content Extractor';
Update Screens set OrderNo = 15 where name = 'Document Status';
Update Screens set OrderNo = 16 where name = 'Document Meta Tags';
Update Screens set OrderNo = 17 where name = 'Document Category';
Update Screens set OrderNo = 18 where name = 'Document Audit Trail';
Update Screens set OrderNo = 19 where name = 'Archive Documents';
Update Screens set OrderNo = 20 where name = 'Archive Folders';
Update Screens set OrderNo = 21 where name = 'Role';
Update Screens set OrderNo = 22 where name = 'User';
Update Screens set OrderNo = 23 where name = 'Reminder';
Update Screens set OrderNo = 24 where name = 'Storage Settings';
Update Screens set OrderNo = 25 where name = 'Company Profile';
Update Screens set OrderNo = 26 Where name = 'Allow File Extensions';
Update Screens set OrderNo = 27 where name = 'Email';
Update Screens set OrderNo = 28 where name = 'Login Audit';
Update Screens set OrderNo = 29 where name = 'Page Helper';
Update Screens set OrderNo = 30 where name = 'Error Logs';

INSERT [dbo].[DocumentMetaTags] ([Id], [Type], [Name], [IsEditable],[CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'f2a72ebe-dc8f-4aba-a116-3251575c7691', 1, N'Created', 0, CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[DocumentMetaTags] ([Id], [Type], [Name], [IsEditable],[CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'563c6044-660f-4b01-8377-52620442c65b', 0, N'Author', 0, CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[DocumentMetaTags] ([Id], [Type], [Name], [IsEditable],[CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'ce54bad3-48f6-4df7-a198-cf2bd9de4998', 1, N'Modified', 0, CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[DocumentMetaTags] ([Id], [Type], [Name], [IsEditable],[CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
	VALUES (N'932f7788-3ae5-4925-92d7-f75dcbecfda9', 0, N'Title', 0, CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250402120541_Version_V6_Data', N'8.0.13');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

DROP TABLE [WorkFlowStepRoles];
GO

DROP TABLE [WorkflowStepUsers];
GO

DROP INDEX [IX_DocumentVersions_DocumentId] ON [DocumentVersions];
GO

DECLARE @var25 sysname;
SELECT @var25 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[WorkflowSteps]') AND [c].[name] = N'IsSignatureRequired');
IF @var25 IS NOT NULL EXEC(N'ALTER TABLE [WorkflowSteps] DROP CONSTRAINT [' + @var25 + '];');
ALTER TABLE [WorkflowSteps] DROP COLUMN [IsSignatureRequired];
GO

ALTER TABLE [WorkflowTransitions] ADD [Color] nvarchar(max) NULL;
GO

ALTER TABLE [WorkflowTransitions] ADD [IsSignatureRequired] bit NOT NULL DEFAULT CAST(0 AS bit);
GO

ALTER TABLE [WorkflowTransitions] ADD [OrderNo] int NOT NULL DEFAULT 0;
GO

ALTER TABLE [Users] ADD [IsSuperAdmin] bit NOT NULL DEFAULT CAST(0 AS bit);
GO

DECLARE @var26 sysname;
SELECT @var26 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[DocumentVersions]') AND [c].[name] = N'Url');
IF @var26 IS NOT NULL EXEC(N'ALTER TABLE [DocumentVersions] DROP CONSTRAINT [' + @var26 + '];');
ALTER TABLE [DocumentVersions] ALTER COLUMN [Url] nvarchar(450) NULL;
GO

ALTER TABLE [Documents] ADD [IsShared] bit NOT NULL DEFAULT CAST(0 AS bit);
GO

ALTER TABLE [DocumentComments] ADD [IsUnreadComment] bit NOT NULL DEFAULT CAST(0 AS bit);
GO

ALTER TABLE [CompanyProfiles] ADD [LogoIconUrl] nvarchar(max) NULL;
GO

ALTER TABLE [CompanyProfiles] ADD [OpenAIAPIKey] nvarchar(max) NULL;
GO

CREATE TABLE [AIPromptTemplates] (
    [Id] uniqueidentifier NOT NULL,
    [Name] nvarchar(max) NULL,
    [Description] nvarchar(max) NULL,
    [PromptInput] nvarchar(max) NULL,
    [IsActive] bit NOT NULL,
    [ModifiedDate] datetime2 NOT NULL,
    CONSTRAINT [PK_AIPromptTemplates] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [UserOpenaiMsgs] (
    [Id] uniqueidentifier NOT NULL,
    [Title] nvarchar(max) NULL,
    [PromptInput] nvarchar(max) NULL,
    [Language] nvarchar(max) NULL,
    [MaximumLength] int NOT NULL,
    [Creativity] decimal(18,6) NOT NULL,
    [ToneOfVoice] nvarchar(max) NULL,
    [SelectedModel] nvarchar(max) NULL,
    [AiResponse] nvarchar(max) NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [ModifiedDate] datetime2 NOT NULL,
    [ModifiedBy] uniqueidentifier NOT NULL,
    [DeletedDate] datetime2 NULL,
    [DeletedBy] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_UserOpenaiMsgs] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_UserOpenaiMsgs_Users_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [Users] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [WorkflowTransitionRoles] (
    [WorkflowTransitionId] uniqueidentifier NOT NULL,
    [RoleId] uniqueidentifier NOT NULL,
    CONSTRAINT [PK_WorkflowTransitionRoles] PRIMARY KEY ([WorkflowTransitionId], [RoleId]),
    CONSTRAINT [FK_WorkflowTransitionRoles_Roles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [Roles] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_WorkflowTransitionRoles_WorkflowTransitions_WorkflowTransitionId] FOREIGN KEY ([WorkflowTransitionId]) REFERENCES [WorkflowTransitions] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [WorkflowTransitionUsers] (
    [WorkflowTransitionId] uniqueidentifier NOT NULL,
    [UserId] uniqueidentifier NOT NULL,
    CONSTRAINT [PK_WorkflowTransitionUsers] PRIMARY KEY ([WorkflowTransitionId], [UserId]),
    CONSTRAINT [FK_WorkflowTransitionUsers_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_WorkflowTransitionUsers_WorkflowTransitions_WorkflowTransitionId] FOREIGN KEY ([WorkflowTransitionId]) REFERENCES [WorkflowTransitions] ([Id]) ON DELETE CASCADE
);
GO

CREATE INDEX [IX_DocumentVersions_DocumentId_Url_CreatedBy] ON [DocumentVersions] ([DocumentId], [Url], [CreatedBy]);
GO

CREATE INDEX [IX_UserOpenaiMsgs_CreatedBy] ON [UserOpenaiMsgs] ([CreatedBy]);
GO

CREATE INDEX [IX_WorkflowTransitionRoles_RoleId] ON [WorkflowTransitionRoles] ([RoleId]);
GO

CREATE INDEX [IX_WorkflowTransitionUsers_UserId] ON [WorkflowTransitionUsers] ([UserId]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250505093157_Version_V7', N'8.0.13');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted], [OrderNo]) VALUES 
(N'479b5173-369e-487a-817d-651d77782590', N'AI Documents', CAST(N'2024-12-23T06:59:21.6608642' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T06:59:21.6666667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0, NULL)
INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted], [OrderNo]) VALUES 
(N'28e6dbe7-1d17-4875-b96f-8757870d20af', N'General Settings', CAST(N'2024-12-23T06:59:21.6608642' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T06:59:21.6666667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0, NULL)

INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES
(N'6c8d16e8-dce5-4849-a31b-e96066e062ff', N'AI Document Generator', CAST(N'2024-12-23T06:59:21.6608642' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T06:59:21.6666667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES
(N'fc8d3588-f9c5-4622-b6de-520848611d03', N'View Prompt Templates', CAST(N'2024-12-23T06:59:21.6608642' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T06:59:21.6666667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'7095b986-8da4-41ba-ba38-d277ed6e7aae', N'General Settings', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'bf5ed8fb-d913-45ed-9670-809772c015ae', N'Add Prompt Templates', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'a02e2461-d227-47d3-8b2c-6a731c0a05c5', N'Edit Prompt Templates', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'83c78502-8162-46e1-be10-0cf5e4633071', N'Delete Prompt Templates', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'a05bc9e5-d42e-4d32-b52d-091b1956621f', N'View AI Document Generator', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)
INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'4175783d-45fa-4a22-82ae-dde0f9540d6f', N'Delete AI Document Generator', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)


INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
VALUES (N'39836641-143c-4e37-bc18-12af4eb95f01', N'6c8d16e8-dce5-4849-a31b-e96066e062ff', N'479b5173-369e-487a-817d-651d77782590', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
VALUES (N'14f96237-e4ad-4cdb-af33-dc0f98abe121', N'fc8d3588-f9c5-4622-b6de-520848611d03', N'479b5173-369e-487a-817d-651d77782590', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
VALUES (N'1d831629-f1b9-4c47-b70d-97893908fb46', N'7095b986-8da4-41ba-ba38-d277ed6e7aae', N'28e6dbe7-1d17-4875-b96f-8757870d20af', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
VALUES (N'37653d9f-73d2-459f-ba17-e678944c0703', N'bf5ed8fb-d913-45ed-9670-809772c015ae', N'479b5173-369e-487a-817d-651d77782590', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
VALUES (N'ed9ec981-4e36-436d-962a-44c2f347213d', N'a02e2461-d227-47d3-8b2c-6a731c0a05c5', N'479b5173-369e-487a-817d-651d77782590', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
VALUES (N'5ea98fd6-f86f-462b-ba4a-c2a7cadcf122', N'83c78502-8162-46e1-be10-0cf5e4633071', N'479b5173-369e-487a-817d-651d77782590', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
VALUES (N'cfde1c32-3f74-47e7-b0c8-f7061acac39b', N'a05bc9e5-d42e-4d32-b52d-091b1956621f', N'479b5173-369e-487a-817d-651d77782590', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
VALUES (N'3c7ea13e-e6be-4035-90cd-9fdf793ce89f', N'4175783d-45fa-4a22-82ae-dde0f9540d6f', N'479b5173-369e-487a-817d-651d77782590', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)
INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
VALUES (N'8c98e9a6-8edc-4e4e-8714-37752437f10d', N'2f5137b5-1e40-49eb-9484-98c1bd2fb8d6', N'5a5f7cf8-21a6-434a-9330-db91b17d867c', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)


INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'6c8d16e8-dce5-4849-a31b-e96066e062ff', N'479b5173-369e-487a-817d-651d77782590', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'AI_Documents_AI_Document_Generator', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'fc8d3588-f9c5-4622-b6de-520848611d03', N'479b5173-369e-487a-817d-651d77782590', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'AI_Documents_View_Prompt_Templates', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'7095b986-8da4-41ba-ba38-d277ed6e7aae', N'28e6dbe7-1d17-4875-b96f-8757870d20af', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'General_Settings_General_Settings', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'bf5ed8fb-d913-45ed-9670-809772c015ae', N'479b5173-369e-487a-817d-651d77782590', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'AI_Documents_Add_Prompt_Templates', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'a02e2461-d227-47d3-8b2c-6a731c0a05c5', N'479b5173-369e-487a-817d-651d77782590', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'AI_Documents_Edit_Prompt_Templates', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'83c78502-8162-46e1-be10-0cf5e4633071', N'479b5173-369e-487a-817d-651d77782590', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'AI_Documents_Delete_Prompt_Templates', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'a05bc9e5-d42e-4d32-b52d-091b1956621f', N'479b5173-369e-487a-817d-651d77782590', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'AI_Documents_View_AI_Document_Generator', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'4175783d-45fa-4a22-82ae-dde0f9540d6f', N'479b5173-369e-487a-817d-651d77782590', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'AI_Documents_Delete_AI_Document_Generator', N'')
INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'2f5137b5-1e40-49eb-9484-98c1bd2fb8d6', N'5a5f7cf8-21a6-434a-9330-db91b17d867c', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Document_Category_Share_Folder', N'')



INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted])
VALUES (N'f0204d1e-59dc-43e1-83d5-86a7124692c4', N'GENERAL_SETTINGS', N'General Settings', N'<h4>Add Signature to PDF</h4><p>Allow users to add a digital signature to the PDF document.</p><blockquote><p><i>This option enables you to insert your signature directly into the PDF file before downloading or sharing it.</i></p></blockquote><h4> OpenAI API Key</h4><p>Enter your OpenAI API key to enable smart features like content summarization, auto-suggestions, and more.</p><blockquote><p><i>Your API key will be used to connect to OpenAI services securely.</i></p></blockquote>', CAST(N'2023-06-02T17:31:21.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2025-04-22T09:14:42.5306409' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
VALUES (N'6879e107-9109-41fc-8628-9b4937d7baaf', N'AI_DOCUMENT_GENERATOR', N'AI Document Generator', N'<h2> AI Document Generator – <strong>What It Does</strong></h2><p>The <strong>AI Document Generator</strong> helps you quickly create high-quality documents using artificial intelligence (AI).<br>You simply select a prompt template, provide some basic information, and the AI writes the full document for you — ready to <strong>save, share, or download</strong>.</p><h2> <strong>Main Functionalities</strong></h2><h3>1. <strong>Select AI Prompt Template</strong></h3><p>Choose a ready-made writing style or document type (like blog post, email, product description, agreement, etc.)<br>Each template tells the AI what kind of document to create.</p><h3>2. <strong>Fill in Prompt Inputs</strong></h3><p>In the selected template, you’ll see words between double asterisks like **topic** or **productName**.<br>You replace these placeholders with your own information.</p><blockquote><p><strong>Example</strong>:<br>Template: <i>"Write a detailed article about <strong>topic</strong>."</i><br>Your Input: <i>"Latest Trends in Electric Vehicles"</i></p></blockquote><h3>3. <strong>Choose Document Settings</strong></h3><ul><li><strong>Language</strong>: Set the language you want the document in (default is English - USA).</li><li><strong>Maximum Length</strong>: Limit how long the output should be.</li><li><strong>Creativity</strong>: Choose if you want the document formal, creative, or somewhere in between.</li><li><strong>Tone of Voice</strong>: Select the style — professional, friendly, persuasive, etc.</li><li><strong>Select Model</strong>: Pick which AI model to use (e.g., GPT-3.5 Turbo).</li></ul><h3>4. <strong>Generate Document</strong></h3><p>Once you fill out the inputs and click <strong>Generate</strong>, the AI will instantly create a professional document for you, based on your selections.</p><h3>5. <strong>Save as PDF</strong></h3><p>After the document is generated, you can <strong>download it as a PDF</strong> file directly from the system.</p><blockquote><p> This is useful for:</p><ul><li>Quickly saving important drafts.</li><li>Sending documents to clients or teams.</li><li>Storing official records.</li></ul></blockquote><h2> <strong>Key Benefits for Users</strong></h2><ul><li>No need to write documents from scratch.</li><li>Easy, fast, and customizable.</li><li>Perfect for business letters, blog posts, agreements, product descriptions, and more.</li><li>Professional-quality output, ready to download as PDF in seconds.</li></ul><h2> <strong>Simple Workflow for Users</strong></h2><ol><li>Select a Template.</li><li>Provide your inputs.</li><li>Set your preferences (language, tone, length).</li><li>Click <strong>Generate</strong>.</li><li>Review the content.</li><li>Click <strong>Save as PDF</strong> — Done!</li></ol>', CAST(N'2023-06-02T17:31:21.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2025-04-22T09:27:55.3455471' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted])
VALUES (N'7b831b4c-2357-4757-8914-e894aa651fbc', N'RECENT_ACTIVITY', N'Recent Activity', N'<p><strong>General Description:</strong></p><p>The "Recent Activity" page provides a detailed view of all actions performed on documents within the DMS. It allows administrators and users with appropriate permissions to monitor and review document-related activities, ensuring transparency and information security.</p><p><strong>Main Components:</strong></p><p><strong>Search Boxes:</strong></p><ul><li><strong>By Document Name:</strong> Allows users to search for a specific document by entering its name or other details.</li><li><strong>By Meta Tag:</strong> Users can enter meta tags to filter and search for specific document-related activities.</li><li><strong>By User:</strong> Enables filtering activities based on the user who performed the operation.</li></ul><p><strong>List of Audited Documents:</strong></p><p>Displays all actions taken on documents in a tabular format.</p><p>Each entry includes details of the action, such as the date, document name, category, operation performed, who performed the operation, to which user, and to which role the operation was directed.</p><p>Users can click on an entry to view additional details or access the associated document.</p><p><strong>List Sorting:</strong></p><p>Users can sort the list by any of the available columns, such as "Date," "Name," "Category Name," "Operation," "Performed by," "Directed to User," and "Directed to Role."</p><p>This feature makes it easier to organize and analyze information based on specific criteria.</p><p><strong>How to Search the Audit History:</strong></p><ul><li>Enter your search criteria in the corresponding search box (document name, meta tag, or user).</li><li>The search results will be displayed in the audited documents list.</li></ul><p><strong>How to Sort the List:</strong></p><ul><li>Click on the column title by which you want to sort the list (e.g., "Date" or "Name").</li><li>The list will automatically reorder based on the selected criterion.</li></ul>', CAST(N'2023-06-02T17:31:21.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2025-04-22T09:17:33.5316594' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted])
VALUES (N'37ba35ed-e90a-42d5-85a4-d57b86ba684c', N'ADD_PROMPT_TEMPLATE', N'Add Prompt Template', N'<h3> <strong>Add Prompt Template – Explanation</strong></h3><p>This section allows users to <strong>create reusable AI prompt templates</strong>. These templates tell the AI how to generate specific types of content (like product descriptions, emails, summaries, etc.), and can include <strong>dynamic placeholders</strong> that will be replaced with user input later.</p><h3> <strong>Field Explanations</strong></h3><h4> <strong>Name</strong> <i>(Required)</i></h4><p>Enter a short title for your template.</p><blockquote><p>Example: <strong>"Product Description Generator"</strong></p></blockquote><h4> <strong>Description</strong> <i>(Optional)</i></h4><p>Briefly explain what this template does and when to use it.</p><blockquote><p>Example: <i>"Generates a marketing-friendly product description based on product name and features."</i></p></blockquote><h4> <strong>Prompt Input</strong> <i>(Required)</i></h4><p>This is where you write the prompt the AI will follow.<br>Use <strong>dynamic words</strong> inside double asterisks to mark where the AI should insert user-specific content.</p><blockquote><p> Format: **DynamicWord**<br>Example:<br><i>"Write a professional description for the product <strong>ProductName</strong> that highlights its key benefits: <strong>ProductBenefits</strong>."</i></p></blockquote><p>These dynamic words will be shown as input fields when the user runs the template.</p><h3> <strong>Why Use Dynamic Words?</strong></h3><p>Dynamic words make the template flexible. You can reuse the same prompt for different inputs, and the system will ask the user to fill in each **DynamicWord**.</p><ul><li>It’s like a fill-in-the-blanks AI form.</li><li>Helps non-technical users interact with AI easily.</li></ul>', CAST(N'2023-06-02T17:31:21.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2025-04-22T09:24:19.8675015' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted])
VALUES (N'df651d24-9598-4fe0-94fe-692b04789004', N'PROMPT_TEMPLATE', N'Prompt Template', N'<p>The <strong>Prompt Template</strong> section is designed to help users create documents using <strong>AI assistance</strong> more easily and efficiently. Instead of writing complex instructions from scratch every time, users can <strong>select or create templates</strong> that tell the AI what to do — this saves time and ensures consistent results.</p><h3> How It Works</h3><p>Each <strong>Prompt Template</strong> includes:</p><ol><li><strong>Action</strong> – This defines what the AI should do (e.g., <i>Generate Summary</i>, <i>Write Email</i>, <i>Create Report</i>).</li><li><strong>Name</strong> – A short, clear title for the template. This helps users identify it quickly.</li><li><strong>Description</strong> – A simple explanation of what the template is for and when to use it.</li><li><strong>Prompt Input</strong> – The information the user needs to provide so the AI can generate the correct output. For example: topic, customer name, product details, etc.</li></ol><h3> Why It’s Useful</h3><ul><li><strong>Easy to Use</strong>: Even users with no technical knowledge can generate documents by just filling in a few blanks.</li><li><strong>Saves Time</strong>: No need to write instructions from scratch each time.</li><li><strong>Consistent Output</strong>: Helps produce clear and structured documents every time.</li><li><strong>Flexible</strong>: Can be used for multiple use cases — from writing letters to summarizing meeting notes.</li></ul>', CAST(N'2023-06-02T17:31:21.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2025-04-22T09:21:14.3021293' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
VALUES (N'05f30717-e712-4bf8-be5d-8769328cba0f', N'AI_DOCUMENT_GENERATOR_DETAILS', N'AI Document Generator Details', N'<h3><strong>Overview of Your Document Creation Process</strong></h3><p>The <strong>AI Document Generator Details</strong> page helps you customize and generate documents based on the information you provide. Below is a breakdown of the steps and settings:</p><h3>1. <strong>Select AI Prompt Template</strong></h3><ul><li>Choose a <strong>pre-made template</strong> from options like Business Proposal, Blog Post, or Product Description.</li><li>Each template is designed to guide the AI in generating the type of document you need.</li></ul><h3>2. <strong>Prompt Input</strong></h3><ul><li><strong>Replace the placeholders</strong> in the template with your specific information.<ul><li>For example, if the template says:<br>“Write a detailed business proposal about <strong>product</strong>,”<br>you can replace <strong>product</strong> with “Electric Vehicles.”</li><li>This helps the AI understand exactly what you''re asking for and generates the document accordingly.</li></ul></li></ul><h3>3. <strong>Language</strong></h3><ul><li>Select the <strong>language</strong> you want your document to be generated in. The default is <strong>English (USA)</strong>, but you can choose from other available languages as well.</li></ul><h3>4. <strong>Maximum Length</strong></h3><ul><li>Set a <strong>maximum word count</strong> for your document. This helps control how long or short the output will be.<ul><li>For example, if you set it to <strong>100 words</strong>, the AI will aim to generate a document that’s around that length.</li></ul></li></ul><h3>5. <strong>Creativity</strong></h3><ul><li>Choose how <strong>creative</strong> you want the document to be:<ul><li><strong>Formal</strong>: Ideal for professional documents.</li><li><strong>Creative</strong>: Great for informal or engaging content.</li><li><strong>Neutral</strong>: A balanced mix between formal and creative.</li></ul></li></ul><h3>6. <strong>Tone of Voice</strong></h3><ul><li>Select the <strong>tone</strong> you prefer for your document:<ul><li><strong>Professional</strong>: For business-like communication.</li><li><strong>Friendly</strong>: For casual, approachable writing.</li><li><strong>Persuasive</strong>: Ideal for marketing or proposal documents.</li></ul></li></ul><h3>7. <strong>Select AI Model</strong></h3><ul><li>Pick which <strong>AI model</strong> you want to use (e.g., <strong>GPT-3.5 Turbo</strong>). The model you choose can affect the document''s style and quality.</li></ul><h3>8. <strong>Document Summary</strong></h3><ul><li>After filling out all the details, a <strong>summary of your document</strong> will be shown, which includes:<ul><li>The title or type of document.</li><li>The language and tone selected.</li><li>Any specific details based on your inputs.</li></ul></li></ul><p>This summary lets you review everything generated the document.</p>', CAST(N'2023-06-02T17:31:21.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2025-04-29T10:38:15.2654650' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)
INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
VALUES (N'03beeb7c-5ebf-4722-8d9c-484ae8fd8500', N'AI_DOCUMENT_GENERATOR_LIST', N'AI Document Generator List – Manage Your Generated Documents', N'<p>The <strong>AI Document Generator List</strong> allows users to view, manage, and organize all documents created using the AI Document Generator. It provides a detailed table that makes it easy to track and work with your past document generations.</p><h3>&nbsp;<strong>Main Functionalities</strong></h3><ol><li><strong>View Generated Documents</strong></li></ol><p>All documents you’ve generated are listed in a simple, searchable table. Each entry includes:</p><ul><li><strong>Date &amp; Time</strong>: When the document was generated.</li><li><strong>Title</strong>: The name or type of the document (e.g., Business Proposal, Blog Post Idea).</li><li><strong>Prompt Input</strong>: A summary of what you asked the AI to generate.</li><li><strong>Selected Model</strong>: The AI model used (e.g., GPT-3.5 Turbo).</li></ul><p>You can click on a document row to <strong>view the full details</strong> of that document.</p><ol><li><strong>Search by Prompt Input</strong></li></ol><p>Use the built-in search bar to quickly find any document based on keywords from the prompt.<br>This is useful when you’ve generated many documents and want to locate a specific one without scrolling.</p><ol><li><strong>Delete a Document</strong></li></ol><p>If you no longer need a document, you can delete it directly from the list.</p><ul><li>Click the <strong>Delete</strong> icon or button next to the document entry.</li><li>A confirmation prompt will appear before deletion.</li><li>Once deleted, the document will be removed from your list permanently.</li></ul><h3>&nbsp;<strong>Why This Feature Is Useful</strong></h3><ul><li>Keeps your workspace organized.</li><li>Lets you revisit or review past work at any time.</li><li>Helps you avoid clutter by deleting unneeded documents.</li><li>Makes document management simple and efficient.</li></ul><h3><strong>Simple Workflow for Users</strong></h3><ol><li>Open the <strong>Document Generator List</strong>.</li><li>Use the <strong>search bar</strong> to filter by prompt keywords.</li><li>Click a row to <strong>view document details</strong>.</li><li>Click <strong>Delete</strong> if you want to remove a document.</li></ol>', CAST(N'2023-06-02T17:31:21.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2025-04-29T10:34:03.2583971' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0)


Update Screens set OrderNo = 1 where name = 'Dashboard';
Update Screens set OrderNo = 2 where name = 'Assigned Documents';
Update Screens set OrderNo = 3 where name = 'Assigned Folders';
Update Screens set OrderNo = 4 where name = 'All Documents';
Update Screens set OrderNo = 5 where name = 'All Folders';
Update Screens set OrderNo = 6 where name = 'Document Category';
Update Screens set OrderNo = 7 where name = 'Deep Search';
Update Screens set OrderNo = 8 where name = 'AI Documents';
Update Screens set OrderNo = 9 where name = 'OCR Content Extractor';
Update Screens set OrderNo = 10 where name = 'Bulk Document Uploads';
Update Screens set OrderNo = 11 where name = 'File Request';
Update Screens set OrderNo = 12 where name = 'Current Workflow';
Update Screens set OrderNo = 13 where name = 'Workflows';
Update Screens set OrderNo = 14 where name = 'Workflow Settings';
Update Screens set OrderNo = 15 where name = 'Workflow Logs';
Update Screens set OrderNo = 16 where name = 'Reminder';
Update Screens set OrderNo = 17 where name = 'Document Audit Trail';
Update Screens set OrderNo = 18 where name = 'Archive Documents';
Update Screens set OrderNo = 19 where name = 'Archive Folders';
Update Screens set OrderNo = 20 where name = 'Document Status';
Update Screens set OrderNo = 21 where name = 'Clients';
Update Screens set OrderNo = 22 where name = 'Role';
Update Screens set OrderNo = 23 where name = 'User';
Update Screens set OrderNo = 24 where name = 'Email';
Update Screens set OrderNo = 25 where name = 'General Settings';
Update Screens set OrderNo = 26 where name = 'Storage Settings';
Update Screens set OrderNo = 27 where name = 'Page Helper';
Update Screens set OrderNo = 28 where name = 'Allow File Extensions';
Update Screens set OrderNo = 29 where name = 'Company Profile';
Update Screens set OrderNo = 30 where name = 'Document Meta Tags';
Update Screens set OrderNo = 31 where name = 'Login Audit';
Update Screens set OrderNo = 32 where name = 'Error Logs';

Update Users set IsSuperAdmin = 1 where id = '4b352b37-332a-40c6-ab05-e38fcf109719';

Update CompanyProfiles set LogoIconUrl = 'logo-small.png' where id = '5bf73f1d-4679-4901-b833-7963b2799f33';

INSERT INTO [dbo].[AIPromptTemplates] 
([Id], [Name], [Description], [PromptInput], [IsActive], [ModifiedDate]) 
VALUES 
(N'0e832c07-8a82-4a5b-b415-cc4b466a9056', N'Generate tags and keywords for youtube video', N'Generate tags and keywords for youtube video', N'Generate tags and keywords about **title** for youtube video.', 1, CAST(N'2025-04-24T08:06:48.000000' AS DATETIME2)),
(N'18849032-284e-4ea5-adaf-35ee52e4ddc4', N'Generate testimonial', N'Generate testimonial', N'Generate testimonial for **subject**. Include details about how it helped you and what you like best about it.', 1, CAST(N'2025-04-24T07:57:12.000000' AS DATETIME2)),
(N'1a4e4a31-f197-4e6f-a58a-e599f216f6ce', N'Generate blog post conclusion', N'Generate blog post conclusion', N'Write blog post conclusion about title: **title**. And the description is **description**.', 1, CAST(N'2025-04-24T08:03:29.000000' AS DATETIME2)),
(N'20804416-cb1b-4016-840d-6f6d625ac210', N'Write Problem Agitate Solution', N'Write Problem Agitate Solution', N'Write Problem-Agitate-Solution copy for the **description**.', 1, CAST(N'2025-04-24T07:57:56.000000' AS DATETIME2)),
(N'30d72e36-1ef7-4ba9-8a8d-db119c013157', N'Generate Google ads headline for product.', N'Generate Google ads headline for product.', N'Write Google ads headline product name: **product name**. Description is **description**. Audience is **audience**.', 1, CAST(N'2025-04-24T08:47:44.000000' AS DATETIME2)),
(N'3b28ed3a-88e3-4d04-8537-039202c28977', N'Write me blog section', N'Write me blog section', N'Write me blog section about **description**.', 1, CAST(N'2025-04-24T07:58:20.000000' AS DATETIME2)),
(N'3bbe9346-2d34-4f43-8510-ab0f2b290459', N'Generate Instagram post caption', N'Generate Instagram post caption', N'Write Instagram post caption about **title**.', 1, CAST(N'2025-04-24T08:07:26.000000' AS DATETIME2)),
(N'3bc3216e-f5c2-4e93-ae40-50100b166f65', N'Post Generator', N'Generator Post using Open AI.', N'Write a post about **description**.', 1, CAST(N'2025-04-23T13:51:27.000000' AS DATETIME2)),
(N'6e80ce92-ebad-4fbe-a466-d26273695fc7', N'Article Generator', N'Instantly create unique articles on any topic. Boost engagement, improve SEO, and save time.', N'Generate article about **article title**', 1, CAST(N'2025-04-23T13:36:00.000000' AS DATETIME2)),
(N'783724b2-f4ed-473b-af76-6952724aa880', N'Generate instagram hastags.', N'Generate instagram hastags.', N'Write instagram hastags for **keywords**.', 1, CAST(N'2025-04-24T08:07:57.000000' AS DATETIME2)),
(N'8650d81b-2cf3-4fa3-9123-7426bbbd4d94', N'Write product description for Product name', N'Write product description for Product name', N'Write product description for **product name**.', 1, CAST(N'2025-04-24T07:55:55.000000' AS DATETIME2)),
(N'8985b3bb-c69d-4d3b-a8bc-6baecef2c358', N'Generate google ads description for product.', N'Generate google ads description for product.', N'Write google ads description product name: **product name**. Description is **description**. Audience is **audience**.', 1, CAST(N'2025-04-24T08:49:24.000000' AS DATETIME2)),
(N'8a361cde-138b-4fcd-950b-8e759983a3ac', N'Grammar Correction', N'Grammar Correction', N'Correct the grammar. Text is **description**.', 1, CAST(N'2025-04-24T08:55:42.000000' AS DATETIME2)),
(N'8c288cf3-1ff0-4d40-a98c-2744b954e54f', N'Generate pros & cons', N'Generate pros & cons', N'Generate pros & cons about title:  **title**. Description is **description**.', 1, CAST(N'2025-04-24T08:50:36.000000' AS DATETIME2)),
(N'8c94a143-a07e-4c9d-947c-6a1168c68647', N'Email Generator', N'Email Generator', N'Write email about title: **subject**, description: **description**.', 1, CAST(N'2025-04-24T08:51:56.000000' AS DATETIME2)),
(N'913a8628-b4f2-41e2-a1aa-f44331afcf00', N'Newsletter Generator', N'Newsletter Generator', N'generate newsletter template about product title: **title**, reason: **subject** description: **description**.', 1, CAST(N'2025-04-24T08:53:00.000000' AS DATETIME2)),
(N'98511559-7b1a-42f6-b924-2430a1bdfd5a', N'Generate Facebook ads title', N'Generate Facebook ads title', N'Write Facebook ads title about title: **title**. And description is **description**.', 1, CAST(N'2025-04-24T08:46:58.000000' AS DATETIME2)),
(N'a72ce7d0-720f-48ac-b7f7-7ab25d73a72c', N'Summarize Text', N'Summarize Text', N'Summarize the following text: **text**.', 1, CAST(N'2025-04-23T13:57:10.000000' AS DATETIME2)),
(N'b9e114c7-a2f1-4777-b43a-e36b1e146dbc', N'FAQ Generator', N'FAQ Generator', N'Answer like faq about subject: **title** Description is **description**.', 1, CAST(N'2025-04-24T08:51:34.000000' AS DATETIME2)),
(N'c1804540-d86a-48c6-a321-05f13630f262', N'Generate website meta description', N'Generate website meta description', N'Generate website meta description site name: **title** Description is **description**.', 1, CAST(N'2025-04-24T08:51:04.000000' AS DATETIME2)),
(N'ca26c30b-e537-4c9f-a4b9-ec4cc7b95a1b', N'Rewrite content', N'Rewrite content', N'Rewrite content:  **contents**.', 1, CAST(N'2025-04-24T08:49:45.000000' AS DATETIME2)),
(N'd35d6c5d-9146-464e-bfa9-196f9db0b251', N'Generate one paragraph', N'Generate one paragraph', N'Generate one paragraph about:  **description**. Keywords are **keywords**.', 1, CAST(N'2025-04-24T08:50:11.000000' AS DATETIME2)),
(N'd8d81df2-2859-4c6d-99aa-eb6dabb9cc01', N'Post Title Generator', N'Generator a Post Title from Post Description.', N'Generate Post title about **description**', 1, CAST(N'2025-04-23T13:55:24.000000' AS DATETIME2)),
(N'ddf9b4d8-1ffc-4582-92f7-6e4adc667c95', N'Generate company social media post', N'Generate company social media post', N'Write in company social media post, company name: **company name**. About: **description**.', 1, CAST(N'2025-04-24T08:44:33.000000' AS DATETIME2)),
(N'e884ec96-547c-4f81-99e9-40eed842f8b5', N'Generate youtube video description', N'Generate youtube video description', N'write youtube video description about **title**.', 1, CAST(N'2025-04-24T08:05:13.000000' AS DATETIME2)),
(N'ea82c689-ad2a-4b54-b11b-4545af7a236d', N'Generate YouTube video titles', N'Generate YouTube video titles', N'Craft captivating, attention-grabbing video titles about **description** for YouTube rankings.', 1, CAST(N'2025-04-24T08:06:08.000000' AS DATETIME2)),
(N'f3431223-1eba-4f47-b1f5-8a990a3022af', N'Email Answer Generator', N'Email Answer Generator', N'answer this email content: **description**.', 1,CAST(N'2025-04-24T08:52:18.000000' AS DATETIME2)),
(N'f7057b73-0db5-4fe6-bc5e-44cb9e1b35e4', N'Generate blog post introduction', N'Generate blog post introduction', N'Write blog post intro about title: **title**. And the description is **description**.',1, CAST('2025-04-24T08:02:27.000000' AS DATETIME2)),
(N'fd71e2b4-427f-40d9-8ab3-b616fc0cf09b', N'Generate Facebook ads text', N'Generate Facebook ads text', N'Write facebook ads text about title: **title**. And the description is **description**.', 1,CAST('2025-04-24T08:04:16.000000' AS DATETIME2)),
(N'fe9b5264-64a2-4772-a033-00088cf11d07', N'Generate blog post idea', N'Generate blog post idea', N'Write blog post article ideas about **description**.', 1,CAST('2025-04-24T08:01:51.000000' AS DATETIME2));

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250505093213_Version_V7_Data', N'8.0.13');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

DECLARE @var27 sysname;
SELECT @var27 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[DocumentComments]') AND [c].[name] = N'IsUnreadComment');
IF @var27 IS NOT NULL EXEC(N'ALTER TABLE [DocumentComments] DROP CONSTRAINT [' + @var27 + '];');
ALTER TABLE [DocumentComments] DROP COLUMN [IsUnreadComment];
GO

ALTER TABLE [WorkflowSteps] ADD [OrderNo] int NOT NULL DEFAULT 0;
GO

ALTER TABLE [Users] ADD [IsSystemUser] bit NOT NULL DEFAULT CAST(0 AS bit);
GO

DECLARE @var28 sysname;
SELECT @var28 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[UserOpenaiMsgs]') AND [c].[name] = N'Creativity');
IF @var28 IS NOT NULL EXEC(N'ALTER TABLE [UserOpenaiMsgs] DROP CONSTRAINT [' + @var28 + '];');
ALTER TABLE [UserOpenaiMsgs] ALTER COLUMN [Creativity] decimal(18,2) NOT NULL;
GO

ALTER TABLE [Documents] ADD [ArchiveById] uniqueidentifier NULL;
GO

ALTER TABLE [Documents] ADD [OnExpiryAction] int NULL;
GO

ALTER TABLE [Documents] ADD [RetentionDate] date NULL;
GO

ALTER TABLE [Documents] ADD [RetentionPeriodInDays] int NULL;
GO

ALTER TABLE [DocumentIndexes] ADD [DocumentId] uniqueidentifier NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000';
GO

ALTER TABLE [CompanyProfiles] ADD [LicenseKey] nvarchar(max) NULL;
GO

ALTER TABLE [CompanyProfiles] ADD [PurchaseCode] nvarchar(max) NULL;
GO

ALTER TABLE [Categories] ADD [ArchiveById] uniqueidentifier NULL;
GO

CREATE TABLE [ArchiveRetentions] (
    [Id] uniqueidentifier NOT NULL,
    [RetentionPeriodInDays] int NULL,
    [IsEnabled] bit NOT NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [ModifiedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
    [ModifiedBy] uniqueidentifier NOT NULL,
    [DeletedDate] datetime2 NULL,
    [DeletedBy] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_ArchiveRetentions] PRIMARY KEY ([Id])
);
GO

CREATE INDEX [IX_Documents_ArchiveById] ON [Documents] ([ArchiveById]);
GO

CREATE INDEX [IX_Categories_ArchiveById] ON [Categories] ([ArchiveById]);
GO

ALTER TABLE [Categories] ADD CONSTRAINT [FK_Categories_Users_ArchiveById] FOREIGN KEY ([ArchiveById]) REFERENCES [Users] ([Id]);
GO

ALTER TABLE [Documents] ADD CONSTRAINT [FK_Documents_Users_ArchiveById] FOREIGN KEY ([ArchiveById]) REFERENCES [Users] ([Id]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250623073027_Version_V8', N'8.0.13');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

INSERT [dbo].[Users] ([Id],[FirstName],[LastName],[IsDeleted],[IsSuperAdmin],[ClientId],[ClientSecretHash],[IsSystemUser],[UserName],[NormalizedUserName],[Email],[NormalizedEmail],[EmailConfirmed],[PasswordHash],[SecurityStamp],[ConcurrencyStamp],[PhoneNumber],[PhoneNumberConfirmed],[TwoFactorEnabled],[LockoutEnd],[LockoutEnabled],[AccessFailedCount]) VALUES (N'6e8b6f4a-9c7d-47b6-a476-b94ac78e2db1',N'System',N'User',0,0,NULL,NULL,1,N'systemuser@gmail.com',N'SYSTEMUSER@GMAIL.COM',N'systemuser@gmail.com',N'SYSTEMUSER@GMAIL.COM',0,N'AQAAAAEAACcQAAAAEM60FYHL5RMKNeB+CxCOI41EC8Vsr1B3Dyrrr2BOtZrxz6doL8o6Tv/tYGDRk20t1A==',N'f3bda79c-c5e4-47ad-bdf5-d8d01c983de2',N'b8f676e1-3e2a-4c3c-b58d-772a9c47e4f9',N'1234567890',0,0,NULL,1,0);

INSERT [dbo].[Screens] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted], [OrderNo]) VALUES 
(N'9e58a819-05ce-4226-ad70-31d2897f94be', N'Archive Retention Period', CAST(N'2024-12-23T06:59:21.6608642' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T06:59:21.6666667' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0, NULL)

INSERT [dbo].[Operations] ([Id], [Name], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES 
(N'2601bd5f-7987-4cfb-a874-b699a5be3172', N'Manage Archive Retention Period', CAST(N'2024-12-23T08:22:37.8537805' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2024-12-23T08:22:37.8633333' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, NULL, 0)

INSERT [dbo].[ScreenOperations] ([Id], [OperationId], [ScreenId], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) 
VALUES (N'd5e8bac8-c173-459b-be1d-394b2b46f2d9', N'2601bd5f-7987-4cfb-a874-b699a5be3172', N'9e58a819-05ce-4226-ad70-31d2897f94be', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', CAST(N'2024-10-22T16:18:01.0788250' AS DateTime2), N'00000000-0000-0000-0000-000000000000', NULL, N'00000000-0000-0000-0000-000000000000', 0)

INSERT [dbo].[RoleClaims] ([OperationId], [ScreenId], [RoleId], [ClaimType], [ClaimValue]) VALUES 
(N'2601bd5f-7987-4cfb-a874-b699a5be3172', N'9e58a819-05ce-4226-ad70-31d2897f94be', N'fedeac7a-a665-40a4-af02-f47ec4b7aff5', N'Archive_Retention_Period_Manage_Archive_Retention_Period', N'')

Update Screens set OrderNo = 20 where name = 'Archive Retention Period';
Update Screens set OrderNo = 21 where name = 'Document Status';
Update Screens set OrderNo = 22 where name = 'Clients';
Update Screens set OrderNo = 23 where name = 'Role';
Update Screens set OrderNo = 24 where name = 'User';
Update Screens set OrderNo = 25 where name = 'Email';
Update Screens set OrderNo = 26 where name = 'General Settings';
Update Screens set OrderNo = 27 where name = 'Storage Settings';
Update Screens set OrderNo = 28 where name = 'Page Helper';
Update Screens set OrderNo = 29 where name = 'Allow File Extensions';
Update Screens set OrderNo = 30 where name = 'Company Profile';
Update Screens set OrderNo = 31 where name = 'Document Meta Tags';
Update Screens set OrderNo = 32 where name = 'Login Audit';
Update Screens set OrderNo = 33 where name = 'Error Logs';

INSERT [dbo].[PageHelpers] ([Id], [Code], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [DeletedDate], [DeletedBy], [IsDeleted]) VALUES (N'0b6c1861-8bf3-413f-980c-1ea483cd5102', N'ARCHIVE_RETENTION_PERIOD', N'Archive Retention Period', N'<p><strong>What is it?</strong><br>Archive Retention Period allows you to automatically move documents to the <strong>delete</strong> after a selected number of days.</p><p><strong>Retention Options:</strong><br>You can choose to automatically archive documents after:</p><p>30 days</p><p>60 days</p><p>90 days</p><p>180 days</p><p>365 days</p><p><strong>How it works:</strong><br>Once this setting is enabled:</p><p>The system will monitor the age of each document.</p><p>When a document reaches the selected retention period (e.g., 30 days), it will be <strong>automatically deleted</strong>.</p><p>Archived documents are removed from the active list but remain accessible for viewing or restoring.</p><p>&nbsp;<i>Enabling this feature helps keep your workspace organized by moving older documents out of the way.</i></p>', CAST(N'2023-06-02T17:31:21.0000000' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', CAST(N'2025-06-23T10:14:50.4949395' AS DateTime2), N'4b352b37-332a-40c6-ab05-e38fcf109719', NULL, NULL, 0);

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250623073035_Version_V8_Data', N'8.0.13');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [PageActions] (
    [Id] uniqueidentifier NOT NULL,
    [Name] nvarchar(max) NULL,
    [Order] int NOT NULL,
    [PageId] uniqueidentifier NOT NULL,
    [Code] nvarchar(max) NULL,
    CONSTRAINT [PK_PageActions] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_PageActions_Screens_PageId] FOREIGN KEY ([PageId]) REFERENCES [Screens] ([Id]) ON DELETE CASCADE
);
GO

CREATE INDEX [IX_PageActions_PageId] ON [PageActions] ([PageId]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250911141914_Added_PAGEACTION_Table', N'8.0.13');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

ALTER TABLE [RoleClaims] DROP CONSTRAINT [FK_RoleClaims_Operations_OperationId];
GO

ALTER TABLE [UserClaims] DROP CONSTRAINT [FK_UserClaims_Operations_OperationId];
GO

DECLARE @var29 sysname;
SELECT @var29 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[UserClaims]') AND [c].[name] = N'OperationId');
IF @var29 IS NOT NULL EXEC(N'ALTER TABLE [UserClaims] DROP CONSTRAINT [' + @var29 + '];');
ALTER TABLE [UserClaims] ALTER COLUMN [OperationId] uniqueidentifier NULL;
GO

ALTER TABLE [UserClaims] ADD [PageActionId] uniqueidentifier NULL;
GO

DECLARE @var30 sysname;
SELECT @var30 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[RoleClaims]') AND [c].[name] = N'OperationId');
IF @var30 IS NOT NULL EXEC(N'ALTER TABLE [RoleClaims] DROP CONSTRAINT [' + @var30 + '];');
ALTER TABLE [RoleClaims] ALTER COLUMN [OperationId] uniqueidentifier NULL;
GO

ALTER TABLE [RoleClaims] ADD [PageActionId] uniqueidentifier NULL;
GO

CREATE INDEX [IX_UserClaims_PageActionId] ON [UserClaims] ([PageActionId]);
GO

CREATE INDEX [IX_RoleClaims_PageActionId] ON [RoleClaims] ([PageActionId]);
GO

ALTER TABLE [RoleClaims] ADD CONSTRAINT [FK_RoleClaims_Operations_OperationId] FOREIGN KEY ([OperationId]) REFERENCES [Operations] ([Id]);
GO

ALTER TABLE [RoleClaims] ADD CONSTRAINT [FK_RoleClaims_PageActions_PageActionId] FOREIGN KEY ([PageActionId]) REFERENCES [PageActions] ([Id]);
GO

ALTER TABLE [UserClaims] ADD CONSTRAINT [FK_UserClaims_Operations_OperationId] FOREIGN KEY ([OperationId]) REFERENCES [Operations] ([Id]);
GO

ALTER TABLE [UserClaims] ADD CONSTRAINT [FK_UserClaims_PageActions_PageActionId] FOREIGN KEY ([PageActionId]) REFERENCES [PageActions] ([Id]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250911143455_Added_PageActionId_Into_UserClaim_RoleClaim', N'8.0.13');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

ALTER TABLE [RoleClaims] DROP CONSTRAINT [FK_RoleClaims_Screens_ScreenId];
GO

ALTER TABLE [UserClaims] DROP CONSTRAINT [FK_UserClaims_Screens_ScreenId];
GO

DECLARE @var31 sysname;
SELECT @var31 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[UserClaims]') AND [c].[name] = N'ScreenId');
IF @var31 IS NOT NULL EXEC(N'ALTER TABLE [UserClaims] DROP CONSTRAINT [' + @var31 + '];');
ALTER TABLE [UserClaims] ALTER COLUMN [ScreenId] uniqueidentifier NULL;
GO

DECLARE @var32 sysname;
SELECT @var32 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[RoleClaims]') AND [c].[name] = N'ScreenId');
IF @var32 IS NOT NULL EXEC(N'ALTER TABLE [RoleClaims] DROP CONSTRAINT [' + @var32 + '];');
ALTER TABLE [RoleClaims] ALTER COLUMN [ScreenId] uniqueidentifier NULL;
GO

ALTER TABLE [RoleClaims] ADD CONSTRAINT [FK_RoleClaims_Screens_ScreenId] FOREIGN KEY ([ScreenId]) REFERENCES [Screens] ([Id]);
GO

ALTER TABLE [UserClaims] ADD CONSTRAINT [FK_UserClaims_Screens_ScreenId] FOREIGN KEY ([ScreenId]) REFERENCES [Screens] ([Id]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250911143705_Allow_ScreenId_Null', N'8.0.13');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO


            INSERT INTO PageActions (Id, Name, [Order], PageId, Code)
            SELECT 
                so.Id, -- Use ScreenOperation.Id as PageAction.Id
                s.Name + '_' + o.Name AS Name,
                ROW_NUMBER() OVER(PARTITION BY so.ScreenId ORDER BY o.Name) AS [Order],
                so.ScreenId AS PageId,
                 REPLACE(o.Name, ' ', '_') AS Code
            FROM ScreenOperations so
            INNER JOIN Screens s ON so.ScreenId = s.Id
            INNER JOIN Operations o ON so.OperationId = o.Id
        
GO


        UPDATE uc
        SET PageActionId = so.Id
        FROM UserClaims uc
        INNER JOIN ScreenOperations so 
            ON uc.OperationId = so.OperationId AND uc.ScreenId = so.ScreenId
    
GO


        UPDATE rc
        SET PageActionId = so.Id
        FROM RoleClaims rc
        INNER JOIN ScreenOperations so 
            ON rc.OperationId = so.OperationId AND rc.ScreenId = so.ScreenId
    
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250911143903_Entry_Into_PageAction', N'8.0.13');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO


            UPDATE pa
            SET pa.Code = REPLACE(o.Name, ' ', '_')
            FROM PageActions pa
            INNER JOIN ScreenOperations so ON pa.Id = so.Id
            INNER JOIN Operations o ON so.OperationId = o.Id
            
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250911150429_Update_PageAction_Code', N'8.0.13');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

ALTER TABLE [RoleClaims] DROP CONSTRAINT [FK_RoleClaims_Operations_OperationId];
GO

ALTER TABLE [RoleClaims] DROP CONSTRAINT [FK_RoleClaims_Screens_ScreenId];
GO

ALTER TABLE [UserClaims] DROP CONSTRAINT [FK_UserClaims_Operations_OperationId];
GO

ALTER TABLE [UserClaims] DROP CONSTRAINT [FK_UserClaims_Screens_ScreenId];
GO

DROP INDEX [IX_UserClaims_OperationId] ON [UserClaims];
GO

DROP INDEX [IX_UserClaims_ScreenId] ON [UserClaims];
GO

DROP INDEX [IX_RoleClaims_OperationId] ON [RoleClaims];
GO

DROP INDEX [IX_RoleClaims_ScreenId] ON [RoleClaims];
GO

DECLARE @var33 sysname;
SELECT @var33 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[UserClaims]') AND [c].[name] = N'OperationId');
IF @var33 IS NOT NULL EXEC(N'ALTER TABLE [UserClaims] DROP CONSTRAINT [' + @var33 + '];');
ALTER TABLE [UserClaims] DROP COLUMN [OperationId];
GO

DECLARE @var34 sysname;
SELECT @var34 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[UserClaims]') AND [c].[name] = N'ScreenId');
IF @var34 IS NOT NULL EXEC(N'ALTER TABLE [UserClaims] DROP CONSTRAINT [' + @var34 + '];');
ALTER TABLE [UserClaims] DROP COLUMN [ScreenId];
GO

DECLARE @var35 sysname;
SELECT @var35 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[RoleClaims]') AND [c].[name] = N'OperationId');
IF @var35 IS NOT NULL EXEC(N'ALTER TABLE [RoleClaims] DROP CONSTRAINT [' + @var35 + '];');
ALTER TABLE [RoleClaims] DROP COLUMN [OperationId];
GO

DECLARE @var36 sysname;
SELECT @var36 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[RoleClaims]') AND [c].[name] = N'ScreenId');
IF @var36 IS NOT NULL EXEC(N'ALTER TABLE [RoleClaims] DROP CONSTRAINT [' + @var36 + '];');
ALTER TABLE [RoleClaims] DROP COLUMN [ScreenId];
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250912044336_Added_Role_And_User_Claim_Remove_Screen_Operation', N'8.0.13');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

DROP TABLE [ScreenOperations];
GO

DROP TABLE [Operations];
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250912063654_REMOVE_OPERATION_OPERATIONSCREEN_TABLES', N'8.0.13');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO


            UPDATE PageActions SET code='ALL_Add_Comment' WHERE Name='All Documents_Add Comment'
    
GO


            UPDATE PageActions SET code='Assigned_Add_Comment' WHERE Name='Assigned Documents_Add Comment'
    
GO


            UPDATE PageActions SET code='ALL_Delete_Comment' WHERE Name='All Documents_Delete Comment'
    
GO


            UPDATE PageActions SET code='Assigned_Delete_Comment' WHERE Name='Assigned Documents_Delete Comment'
    
GO


            UPDATE PageActions SET code='ALL_Remove_Share_Document' WHERE Name='All Documents_Remove Share Document'
    
GO


            UPDATE PageActions SET code='ALL_Share_Document' WHERE Name='All Documents_Share Document'
    
GO


            UPDATE PageActions SET code='Assigned_Remove_Share_Document' WHERE Name='Assigned Documents_Remove Share Document'
    
GO


            UPDATE PageActions SET code='Assigned_Share_Document' WHERE Name='Assigned Documents_Share Document'
    
GO


            UPDATE PageActions SET code='Assigned_Create_Shareable_Link' WHERE Name='Assigned Documents_Create Shareable Link'
    
GO


            UPDATE PageActions SET code='Archive_Create_Shareable_Link' WHERE Name='Archive Documents_Create Shareable Link'
    
GO


            UPDATE PageActions SET code='ALL_Create_Shareable_Link' WHERE Name='All Documents_Create Shareable Link'
    
GO


            UPDATE PageActions SET code='all_view_version_history' WHERE Name='All Documents_View version history'
    
GO


            UPDATE PageActions SET code='Archive_View_version_history' WHERE Name='Archive Documents_View version history'
    
GO


            UPDATE PageActions SET code='Assigned_View_version_history' WHERE Name='Assigned Documents_View version history'
    
GO


            UPDATE PageActions SET code='ALL_Restore_version' WHERE Name='All Documents_Restore version'
    
GO


            UPDATE PageActions SET code='Assigned_Restore_version' WHERE Name='Assigned Documents_Restore version'
    
GO


            UPDATE PageActions SET code='Archive_Send_Email' WHERE Name='Archive Documents_Send Email'
    
GO


            UPDATE PageActions SET code='All_Send_Email' WHERE Name='All Documents_Send Email'
    
GO


            UPDATE PageActions SET code='Assigned_Send_Email' WHERE Name='Assigned Documents_Send Email'
    
GO


            UPDATE PageActions SET code='All_Add_Reminder' WHERE Name='All Documents_Add Reminder'
    
GO


            UPDATE PageActions SET code='Assigned_Add_Reminder' WHERE Name='Assigned Documents_Add Reminder'
    
GO


            UPDATE PageActions SET code='ALL_Archive_Folder' WHERE Name='All Folders_Archive Folder'
    
GO


            UPDATE PageActions SET code='Category_Archive_Folder' WHERE Name='Document Category_Archive Folder'
    
GO


            UPDATE PageActions SET code='Assigned_Archive_Folder' WHERE Name='Assigned Folders_Archive Folder'
    
GO


            UPDATE PageActions SET code='Assigned_Get_Document_Summary' WHERE Name='Assigned Documents_Get Document Summary'
    
GO


            UPDATE PageActions SET code='ALL_Get_Document_Summary' WHERE Name='All Documents_Get Document Summary'
    
GO


            UPDATE PageActions SET code='Assigned_View_Documents' WHERE Name='Assigned Documents_View Documents'
    
GO


            UPDATE PageActions SET code='All_View_Documents' WHERE Name='All Documents_View Documents'
    
GO


            UPDATE PageActions SET code='All_Create_Document' WHERE Name='All Documents_Create Document  '
    
GO


            UPDATE PageActions SET code='Assigned_Create_Document' WHERE Name='Assigned Documents_Create Document'
    
GO


            UPDATE PageActions SET code='Assigned_Edit_Document' WHERE Name='Assigned Documents_Edit Document'
    
GO


            UPDATE PageActions SET code='All_Edit_Document' WHERE Name='All Documents_Edit Document'
    
GO


            UPDATE PageActions SET code='Assigned_Archive_Document' WHERE Name='Assigned Documents_Archive Document'
    
GO


            UPDATE PageActions SET code='All_Archive_Document' WHERE Name='All Documents_Archive Document'
    
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250912095508_Added_Update_Code_Same_ClaimName', N'8.0.13');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO


            UPDATE PageActions SET code='Assigned_Start_Workflow' WHERE Name='Assigned Documents_Start Workflow'
    
GO


            UPDATE PageActions SET code='All_Start_Workflow' WHERE Name='All Documents_Start Workflow'
    
GO


            UPDATE PageActions SET code='All_Add_Signature' WHERE Name='All Documents_Add Signature'
    
GO


            UPDATE PageActions SET code='Assigned_Add_Signature' WHERE Name='Assigned Documents_Add Signature'
    
GO


            UPDATE PageActions SET code='Archive_Download_Document' WHERE Name='Archive Documents_Download Document'
    
GO


            UPDATE PageActions SET code='All_Download_Document' WHERE Name='All Documents_Download Document'
    
GO


            UPDATE PageActions SET code='Assigned_Download_Document' WHERE Name='Assigned Documents_Download Document'
    
GO


            UPDATE PageActions SET code='Assigned_Upload_New_version' WHERE Name='Assigned Documents_Upload New version'
    
GO


            UPDATE PageActions SET code='All_Upload_New_version' WHERE Name='All Documents_Upload New version'
    
GO


            UPDATE PageActions SET code='All_Manage_Indexing' WHERE Name='All Documents_Manage Indexing'
    
GO


            UPDATE PageActions SET code='Assigned_Manage_Indexing' WHERE Name='Assigned Documents_Manage Indexing'
    
GO


            UPDATE PageActions SET code='Category_Share_Folder' WHERE Name='Document Category_Share Folder'
    
GO


            UPDATE PageActions SET code='Assigned_Share_Folder' WHERE Name='Assigned Folders_Share Folder'
    
GO


            UPDATE PageActions SET code='All_Share_Folder' WHERE Name='All Folders_Share Folder'
    
GO


            UPDATE PageActions SET code='Assigned_Remove_Share_Folder' WHERE Name='Assigned Documents_Remove Share Folder'
    
GO


            UPDATE PageActions SET code='All_Remove_Share_Folder' WHERE Name='All Documents_Remove Share Folder'
    
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250912112603_UPDATE_CLAIM_VALUE', N'8.0.13');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO


       UPDATE pa
    SET pa.Name = REPLACE(pa.Name, p.Name + '_', '') 
    FROM PageActions pa
    INNER JOIN Screens p ON pa.PageId = p.Id
    
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250912122753_Remove_PageName_From_PageAction', N'8.0.13');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

ALTER TABLE [CompanyProfiles] ADD [GeminiAPIKey] nvarchar(max) NULL;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250916120955_Added_GeminiAPIKey_CompanyProfile', N'8.0.13');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO


                DELETE RC
                FROM RoleClaims RC
                INNER JOIN PageActions PA ON RC.PageActionId = PA.Id
                WHERE PA.Code IN ('All_Manage_Indexing', 'Assigned_Manage_Indexing', 'Assigned_Download_Document');

                DELETE FROM PageActions
                WHERE Code IN ('All_Manage_Indexing', 'Assigned_Manage_Indexing', 'Assigned_Download_Document');
                    
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20251010105228_Remove_PageAction', N'8.0.13');
GO

COMMIT;
GO

