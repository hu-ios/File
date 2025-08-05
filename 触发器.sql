IF EXISTS(SELECT * FROM sys.triggers WHERE name = 'trg_Sub_Material_Infomation_History')
	DROP TRIGGER trg_Sub_Material_Infomation_History
	GO
-- ���º�ɾ�������Ĵ�����
CREATE TRIGGER trg_Sub_Material_Infomation_History
ON dbo.Sub_Material_Infomation
AFTER UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- ��ȡ������������Ϣ
    DECLARE @LoginName NVARCHAR(128) = SUSER_SNAME(),
            @AppName NVARCHAR(128) = APP_NAME(),
            @HostName NVARCHAR(128) = HOST_NAME(),
            @IPAddress NVARCHAR(48) = CONVERT(NVARCHAR(48), CONNECTIONPROPERTY('client_net_address'));

    -- ������²���
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO dbo.Sub_Material_Infomation_History
        (
            ID, ���̱���, ����Ʒ��, ���ϱ���, ��������, ���Ϲ��, ��������,
            �����Ʒ��, ����ϱ���, ���������, ����Ϲ��, ������Դ��,
            ������������, ����Model��, ����ϵ�������, �������д��,
            �������д����, ����������д��, ��Ϣ����ʱ��, ��Ϣ��д��,
            ChangeDate, ChangeType,
            ִ�в�����, Ӧ�ó�������, �ͻ���������, �ͻ���IP��ַ, ��ǰ�û�
        )
        SELECT 
            d.ID, d.���̱���, d.����Ʒ��, d.���ϱ���, d.��������, d.���Ϲ��, d.��������,
            d.�����Ʒ��, d.����ϱ���, d.���������, d.����Ϲ��, d.������Դ��,
            d.������������, d.����Model��, d.����ϵ�������, d.�������д��,
            d.�������д����, d.����������д��, d.��Ϣ����ʱ��, d.��Ϣ��д��,
            GETDATE(), 'UPDATE',
            ISNULL(d.�������д��, @LoginName), -- ʹ���������д����Ϊִ�в�����
            @AppName, @HostName, @IPAddress,
            ISNULL(d.�������д��, @LoginName)  -- Ҳ��Ϊ��ǰ�û�
        FROM deleted d
        LEFT JOIN inserted i ON d.ID = i.ID
    END
    
    -- ����ɾ������
    IF NOT EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO dbo.Sub_Material_Infomation_History
        (
            ID, ���̱���, ����Ʒ��, ���ϱ���, ��������, ���Ϲ��, ��������,
            �����Ʒ��, ����ϱ���, ���������, ����Ϲ��, ������Դ��,
            ������������, ����Model��, ����ϵ�������, �������д��,
            �������д����, ����������д��, ��Ϣ����ʱ��, ��Ϣ��д��,
            ChangeDate, ChangeType,
            ִ�в�����, Ӧ�ó�������, �ͻ���������, �ͻ���IP��ַ, ��ǰ�û�
        )
        SELECT 
            d.ID, d.���̱���, d.����Ʒ��, d.���ϱ���, d.��������, d.���Ϲ��, d.��������,
            d.�����Ʒ��, d.����ϱ���, d.���������, d.����Ϲ��, d.������Դ��,
            d.������������, d.����Model��, d.����ϵ�������, d.�������д��,
            d.�������д����, d.����������д��, d.��Ϣ����ʱ��, d.��Ϣ��д��,
            GETDATE(), 'DELETE',
            ISNULL(d.�������д��, @LoginName), -- ʹ���������д����Ϊִ�в�����
            @AppName, @HostName, @IPAddress,
            ISNULL(d.�������д��, @LoginName)  -- Ҳ��Ϊ��ǰ�û�
        FROM deleted d
    END
END
GO

-- ��������Ĵ�����
IF EXISTS(SELECT * FROM sys.triggers WHERE name = 'trg_Sub_Material_Infomation_Insert')
	DROP TRIGGER trg_Sub_Material_Infomation_Insert
	GO
CREATE TRIGGER trg_Sub_Material_Infomation_Insert
ON dbo.Sub_Material_Infomation
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- ��ȡ������������Ϣ
    DECLARE @LoginName NVARCHAR(128) = SUSER_SNAME(),
            @AppName NVARCHAR(128) = APP_NAME(),
            @HostName NVARCHAR(128) = HOST_NAME(),
            @IPAddress NVARCHAR(48) = CONVERT(NVARCHAR(48), CONNECTIONPROPERTY('client_net_address'));
    
    INSERT INTO dbo.Sub_Material_Infomation_History
    (
        ID, ���̱���, ����Ʒ��, ���ϱ���, ��������, ���Ϲ��, ��������,
        �����Ʒ��, ����ϱ���, ���������, ����Ϲ��, ������Դ��,
        ������������, ����Model��, ����ϵ�������, �������д��,
        �������д����, ����������д��, ��Ϣ����ʱ��, ��Ϣ��д��,
        ChangeDate, ChangeType,
        ִ�в�����, Ӧ�ó�������, �ͻ���������, �ͻ���IP��ַ, ��ǰ�û�
    )
    SELECT 
        i.ID, i.���̱���, i.����Ʒ��, i.���ϱ���, i.��������, i.���Ϲ��, i.��������,
        i.�����Ʒ��, i.����ϱ���, i.���������, i.����Ϲ��, i.������Դ��,
        i.������������, i.����Model��, i.����ϵ�������, i.�������д��,
        i.�������д����, i.����������д��, i.��Ϣ����ʱ��, i.��Ϣ��д��,
        GETDATE(), 'INSERT',
        ISNULL(i.�������д��, @LoginName), -- ʹ���������д����Ϊִ�в�����
        @AppName, @HostName, @IPAddress,
        ISNULL(i.�������д��, @LoginName)  -- Ҳ��Ϊ��ǰ�û�
    FROM inserted i
END
GO