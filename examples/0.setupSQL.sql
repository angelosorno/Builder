-- Verificar el estado del Event Scheduler
SHOW VARIABLES LIKE 'event_scheduler';

-- Si no está habilitado, habilítalo
SET GLOBAL event_scheduler = ON;