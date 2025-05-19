USE msdb;
GO

-- Xóa job cũ nếu tồn tại
IF EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE name = 'Auto_Sync_Time_Data')
BEGIN
    EXEC msdb.dbo.sp_delete_job @job_name = 'Auto_Sync_Time_Data';
    PRINT 'Đã xóa job cũ Auto_Sync_Time_Data';
END
GO

-- Tạo job mới với cấu hình chính xác
BEGIN TRY
    DECLARE @jobId BINARY(16);
    
    -- Tạo job
    EXEC msdb.dbo.sp_add_job 
        @job_name = 'Auto_Sync_Customer_Data',
        @enabled = 1,
        @description = 'Tự động đồng bộ dữ liệu khách hàng hàng ngày lúc 2:00 AM',
        @job_id = @jobId OUTPUT;
    
    -- Thêm bước thực thi (trỏ đến procedure trong DW)
    EXEC msdb.dbo.sp_add_jobstep
        @job_id = @jobId,
        @step_name = 'Sync_Customer_Data',
        @subsystem = 'TSQL',
        @command = 'EXEC DW.dbo.sp_Load_Dim_Customer;',
        @database_name = 'DW';
    
    -- Tạo lịch trình chính xác 2:00 AM
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name = 'Daily_Sync_Schedule',
        @freq_type = 4, -- Daily
        @freq_interval = 1, -- Mỗi ngày
        @freq_recurrence_factor = 1,
        @active_start_date = 20250101, -- Ngày bắt đầu
        @active_end_date = 99991231, -- Ngày kết thúc
        @active_start_time = 45000; 
    
    -- Gán lịch trình
    EXEC msdb.dbo.sp_attach_schedule
        @job_id = @jobId,
        @schedule_name = 'Daily_Sync_Schedule';
    
    -- Gán job cho SQL Server Agent
    EXEC msdb.dbo.sp_add_jobserver
        @job_id = @jobId;
    
    PRINT 'Đã tạo thành công job Auto_Sync_Customer_Data sẽ chạy hàng ngày lúc 2:00 AM';
END TRY
BEGIN CATCH
    PRINT 'Lỗi khi tạo job: ' + ERROR_MESSAGE();
    

    IF @jobId IS NOT NULL
    BEGIN
        EXEC msdb.dbo.sp_delete_job @job_id = @jobId;
    END;
END CATCH;
GO