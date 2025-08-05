IF EXISTS(SELECT * FROM sys.triggers WHERE name = 'trg_Sub_Material_Infomation_History')
	DROP TRIGGER trg_Sub_Material_Infomation_History
	GO
-- 更新和删除操作的触发器
CREATE TRIGGER trg_Sub_Material_Infomation_History
ON dbo.Sub_Material_Infomation
AFTER UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- 获取操作上下文信息
    DECLARE @LoginName NVARCHAR(128) = SUSER_SNAME(),
            @AppName NVARCHAR(128) = APP_NAME(),
            @HostName NVARCHAR(128) = HOST_NAME(),
            @IPAddress NVARCHAR(48) = CONVERT(NVARCHAR(48), CONNECTIONPROPERTY('client_net_address'));

    -- 处理更新操作
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO dbo.Sub_Material_Infomation_History
        (
            ID, 流程编码, 主料品牌, 主料编码, 主料名称, 主料规格, 物料类型,
            替代料品牌, 替代料编码, 替代料名称, 替代料规格, 需求来源人,
            需求申请日期, 机型Model号, 替代料导入日期, 替代料填写人,
            替代料填写日期, 器件测试填写人, 信息更新时间, 信息填写人,
            ChangeDate, ChangeType,
            执行操作者, 应用程序名称, 客户端主机名, 客户端IP地址, 当前用户
        )
        SELECT 
            d.ID, d.流程编码, d.主料品牌, d.主料编码, d.主料名称, d.主料规格, d.物料类型,
            d.替代料品牌, d.替代料编码, d.替代料名称, d.替代料规格, d.需求来源人,
            d.需求申请日期, d.机型Model号, d.替代料导入日期, d.替代料填写人,
            d.替代料填写日期, d.器件测试填写人, d.信息更新时间, d.信息填写人,
            GETDATE(), 'UPDATE',
            ISNULL(d.替代料填写人, @LoginName), -- 使用替代料填写人作为执行操作者
            @AppName, @HostName, @IPAddress,
            ISNULL(d.替代料填写人, @LoginName)  -- 也作为当前用户
        FROM deleted d
        LEFT JOIN inserted i ON d.ID = i.ID
    END
    
    -- 处理删除操作
    IF NOT EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO dbo.Sub_Material_Infomation_History
        (
            ID, 流程编码, 主料品牌, 主料编码, 主料名称, 主料规格, 物料类型,
            替代料品牌, 替代料编码, 替代料名称, 替代料规格, 需求来源人,
            需求申请日期, 机型Model号, 替代料导入日期, 替代料填写人,
            替代料填写日期, 器件测试填写人, 信息更新时间, 信息填写人,
            ChangeDate, ChangeType,
            执行操作者, 应用程序名称, 客户端主机名, 客户端IP地址, 当前用户
        )
        SELECT 
            d.ID, d.流程编码, d.主料品牌, d.主料编码, d.主料名称, d.主料规格, d.物料类型,
            d.替代料品牌, d.替代料编码, d.替代料名称, d.替代料规格, d.需求来源人,
            d.需求申请日期, d.机型Model号, d.替代料导入日期, d.替代料填写人,
            d.替代料填写日期, d.器件测试填写人, d.信息更新时间, d.信息填写人,
            GETDATE(), 'DELETE',
            ISNULL(d.替代料填写人, @LoginName), -- 使用替代料填写人作为执行操作者
            @AppName, @HostName, @IPAddress,
            ISNULL(d.替代料填写人, @LoginName)  -- 也作为当前用户
        FROM deleted d
    END
END
GO

-- 插入操作的触发器
IF EXISTS(SELECT * FROM sys.triggers WHERE name = 'trg_Sub_Material_Infomation_Insert')
	DROP TRIGGER trg_Sub_Material_Infomation_Insert
	GO
CREATE TRIGGER trg_Sub_Material_Infomation_Insert
ON dbo.Sub_Material_Infomation
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- 获取操作上下文信息
    DECLARE @LoginName NVARCHAR(128) = SUSER_SNAME(),
            @AppName NVARCHAR(128) = APP_NAME(),
            @HostName NVARCHAR(128) = HOST_NAME(),
            @IPAddress NVARCHAR(48) = CONVERT(NVARCHAR(48), CONNECTIONPROPERTY('client_net_address'));
    
    INSERT INTO dbo.Sub_Material_Infomation_History
    (
        ID, 流程编码, 主料品牌, 主料编码, 主料名称, 主料规格, 物料类型,
        替代料品牌, 替代料编码, 替代料名称, 替代料规格, 需求来源人,
        需求申请日期, 机型Model号, 替代料导入日期, 替代料填写人,
        替代料填写日期, 器件测试填写人, 信息更新时间, 信息填写人,
        ChangeDate, ChangeType,
        执行操作者, 应用程序名称, 客户端主机名, 客户端IP地址, 当前用户
    )
    SELECT 
        i.ID, i.流程编码, i.主料品牌, i.主料编码, i.主料名称, i.主料规格, i.物料类型,
        i.替代料品牌, i.替代料编码, i.替代料名称, i.替代料规格, i.需求来源人,
        i.需求申请日期, i.机型Model号, i.替代料导入日期, i.替代料填写人,
        i.替代料填写日期, i.器件测试填写人, i.信息更新时间, i.信息填写人,
        GETDATE(), 'INSERT',
        ISNULL(i.替代料填写人, @LoginName), -- 使用替代料填写人作为执行操作者
        @AppName, @HostName, @IPAddress,
        ISNULL(i.替代料填写人, @LoginName)  -- 也作为当前用户
    FROM inserted i
END
GO