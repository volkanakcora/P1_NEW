INSERT INTO sysengkpi (kpi, availability, date)
VALUES
  ('Toolchain Services - Uptime', 100.00, '2022-10-01'),
  ('Infrastructure Services - Uptime', 100.00, '2022-10-01'),
  ('Platform Services - Uptime', 100.00, '2022-10-01'),
  ('Toolchain Services - Uptime', 99.72, '2022-11-01'),
  ('Toolchain Services - Uptime', 100.00, '2022-12-01'),
  ('Toolchain Services - Uptime', 100.00, '2023-01-01'),
  ('Toolchain Services - Uptime', 100.00, '2023-02-01'),
  ('Toolchain Services - Uptime', 100.00, '2023-03-01'),
  ('Toolchain Services - Uptime', 100.00, '2023-04-01'),
  ('Toolchain Services - Uptime', 100.00, '2023-05-01');


INSERT INTO sysengkpi (kpi, availability, date)
VALUES
  ('Toolchain Services - Uptime', 99.58, '2023-09-01'),
  ('Toolchain Services - Uptime', 100.00, '2023-06-01'),
  ('Toolchain Services - Uptime', 100.00, '2023-07-01'),
  ('Toolchain Services - Uptime', 100.00, '2023-08-01'),
  ('Infrastructure Services - Uptime', 99.98, '2022-12-01'),
  ('Infrastructure Services - Uptime', 100.00, '2023-01-01'),
  ('Infrastructure Services - Uptime', 100.00, '2023-02-01'),
  ('Infrastructure Services - Uptime', 100.00, '2023-03-01'),
  ('Infrastructure Services - Uptime', 99.85, '2023-04-01'),
  ('Infrastructure Services - Uptime', 100.00, '2023-05-01');


INSERT INTO sysengkpi (kpi, availability, date)
VALUES
  ('Infrastructure Services - Uptime', 100.00, '2023-06-01'),
  ('Infrastructure Services - Uptime', 100.00, '2023-07-01'),
  ('Infrastructure Services - Uptime', 100.00, '2023-08-01'),
  ('Infrastructure Services - Uptime', 99.99, '2023-09-01'),
  ('Platform Services - Uptime', 100.00, '2022-11-01'),
  ('Platform Services - Uptime', 100.00, '2022-12-01'),
  ('Platform Services - Uptime', 100.00, '2023-01-01'),
  ('Platform Services - Uptime', 100.00, '2023-02-01'),
  ('Platform Services - Uptime', 100.00, '2023-03-01'),
  ('Platform Services - Uptime', 100.00, '2023-04-01');


INSERT INTO sysengkpi (kpi, availability, date)
VALUES
  ('Platform Services - Uptime', 100.00, '2023-05-01'),
  ('Platform Services - Uptime', 100.00, '2023-06-01'),
  ('Platform Services - Uptime', 100.00, '2023-07-01'),
  ('Platform Services - Uptime', 100.00, '2023-08-01'),
  ('Platform Services - Uptime', 100.00, '2023-09-01'),
  ('Mail Receiver Component Availability', 100.00, '2024-03-01');


INSERT INTO sysengkpi (kpi, availability, date)
VALUES
  ('Infrastructure Services - Uptime', 96.42, '2023-06-01'),
  ('Infrastructure Services - Uptime', 99.94, '2023-07-01'),
  ('Infrastructure Services - Uptime', 100.00, '2023-08-01'),
  ('Infrastructure Services - Uptime', 99.69, '2023-09-01'),
  ('Platform Services - Uptime', 100.00, '2023-10-01'),
  ('Platform Services - Uptime', 99.98, '2023-10-01'),  -- This row has a different availability than what you provided earlier
  ('Infrastructure Services - Uptime', 100.00, '2023-10-01'),  -- This row is missing from your initial data
  ('Toolchain Services - Uptime', 99.98, '2023-10-01'),  -- This row is missing from your initial data
  ('Platform Services - Uptime', 100.00, '2023-11-01'),
  ('Toolchain Services - Uptime', 100.00, '2023-11-01');

INSERT INTO sysengkpi (kpi, availability, date)
VALUES
  ('Toolchain Services - Uptime', 100.00, '2023-12-01'),
  ('Platform Services - Uptime', 100.00, '2023-12-01'),
  ('Infrastructure Services - Uptime', 100.00, '2024-01-01'),
  ('Infrastructure Services - Uptime', 100.00, '2024-02-01'),
  ('Infrastructure Services - Uptime', 100.00, '2024-03-01'),
  ('Platform Services - Uptime', 100.00, '2024-01-01'),
  ('Platform Services - Uptime', 100.00, '2024-02-01'),
  ('Platform Services - Uptime', 100.00, '2024-03-01'),
  ('Toolchain Services - Uptime', 100.00, '2024-01-01'),
  ('Toolchain Services - Uptime', 100.00, '2024-02-01');

INSERT INTO sysengkpi (kpi, availability, date)
VALUES
  ('Toolchain Services - Uptime', 100.00, '2024-03-01'),
  ('Platform Services - Uptime', 99.98, '2023-10-01'),  -- This row corrects a previously provided value
  ('Toolchain Services - Uptime', 99.98, '2023-10-01'),  -- This row was missing from your initial data
  ('Infrastructure Services - Uptime', 100.00, '2024-01-10'),
  ('Infrastructure Services - Uptime', 100.00, '2023-10-01'),  -- This row was missing from your initial data
  ('Platform Services - Uptime', 100.00, '2024-01-10'),
  ('Toolchain Services - Uptime', 100.00, '2024-01-10'),
  ('Infrastructure Services - Uptime', 100.00, '2024-04-01');


INSERT INTO sysengkpi (kpi, availability, date)
VALUES
  ('Infrastructure Services - Uptime', 100.00, '2024-01-10');








englobkpi=# select * from sysengkpi;
                 kpi                  | availability |        date         |           timestamp
--------------------------------------+--------------+---------------------+-------------------------------
 Toolchain Services - Uptime          | 100          | 2022-10-01 00:00:00 | 2023-10-13 14:40:57.735618+02
 Infrastructure Services - Uptime     | 100          | 2022-10-01 00:00:00 | 2023-10-13 10:52:54.103479+02
 Platform Services - Uptime           | 100          | 2022-10-01 00:00:00 | 2023-10-13 11:04:39.85682+02
 Toolchain Services - Uptime          | 99.72        | 2022-11-01 00:00:00 | 2023-10-13 14:52:23.740345+02
 Toolchain Services - Uptime          | 100          | 2022-12-01 00:00:00 | 2023-10-13 14:52:55.570285+02
 Toolchain Services - Uptime          | 100          | 2023-01-01 00:00:00 | 2023-10-13 14:53:21.27241+02
 Toolchain Services - Uptime          | 100          | 2023-02-01 00:00:00 | 2023-10-13 14:53:30.619624+02
 Toolchain Services - Uptime          | 100          | 2023-03-01 00:00:00 | 2023-10-13 14:53:40.704191+02
 Toolchain Services - Uptime          | 100          | 2023-04-01 00:00:00 | 2023-10-13 14:57:51.267562+02
 Toolchain Services - Uptime          | 100          | 2023-05-01 00:00:00 | 2023-10-13 14:58:01.529635+02
 Toolchain Services - Uptime          | 99.58        | 2023-09-01 00:00:00 | 2023-10-13 14:59:34.603917+02
 Toolchain Services - Uptime          | 100          | 2023-06-01 00:00:00 | 2023-10-13 14:58:15.675255+02
 Toolchain Services - Uptime          | 100          | 2023-07-01 00:00:00 | 2023-10-13 14:59:07.301122+02
 Toolchain Services - Uptime          | 100          | 2023-08-01 00:00:00 | 2023-10-13 14:59:16.755568+02
 Infrastructure Services - Uptime     | 99.98        | 2022-12-01 00:00:00 | 2023-10-13 15:04:53.835352+02
 Infrastructure Services - Uptime     | 100          | 2023-01-01 00:00:00 | 2023-10-13 15:05:08.821083+02
 Infrastructure Services - Uptime     | 100          | 2023-02-01 00:00:00 | 2023-10-13 15:05:20.566444+02
 Infrastructure Services - Uptime     | 99.99        | 2023-03-01 00:00:00 | 2023-10-13 15:05:36.860804+02
 Infrastructure Services - Uptime     | 100          | 2023-04-01 00:00:00 | 2023-10-13 15:05:50.548783+02
 Infrastructure Services - Uptime     | 99.98        | 2023-05-01 00:00:00 | 2023-10-13 15:06:06.750644+02
 Infrastructure Services - Uptime     | 96.42        | 2023-06-01 00:00:00 | 2023-10-13 15:06:33.313361+02
 Infrastructure Services - Uptime     | 99.94        | 2023-07-01 00:00:00 | 2023-10-13 15:06:50.062272+02
 Infrastructure Services - Uptime     | 100          | 2023-08-01 00:00:00 | 2023-10-13 15:07:03.93737+02
 Infrastructure Services - Uptime     | 99.69        | 2023-09-01 00:00:00 | 2023-10-13 15:07:20.706449+02
 Platform Services - Uptime           | 100          | 2023-12-01 00:00:00 | 2023-10-13 15:09:34.10866+02
 Platform Services - Uptime           | 100          | 2022-12-01 00:00:00 | 2023-10-13 15:09:47.279501+02
 Platform Services - Uptime           | 100          | 2023-01-01 00:00:00 | 2023-10-13 15:09:57.454767+02
 Platform Services - Uptime           | 100          | 2023-02-01 00:00:00 | 2023-10-13 15:10:04.285218+02
 Platform Services - Uptime           | 100          | 2023-03-01 00:00:00 | 2023-10-13 15:10:12.20056+02
 Platform Services - Uptime           | 100          | 2023-04-01 00:00:00 | 2023-10-13 15:10:18.833608+02
 Platform Services - Uptime           | 100          | 2023-05-01 00:00:00 | 2023-10-13 15:10:25.44081+02
 Platform Services - Uptime           | 100          | 2023-06-01 00:00:00 | 2023-10-13 15:10:32.095267+02
 Platform Services - Uptime           | 100          | 2023-07-01 00:00:00 | 2023-10-13 15:10:38.963114+02
 Platform Services - Uptime           | 100          | 2023-08-01 00:00:00 | 2023-10-13 15:10:47.451524+02
 Platform Services - Uptime           | 100          | 2023-09-01 00:00:00 | 2023-10-13 15:10:58.036673+02
 Infrastructure Services - Uptime     | 100          | 2023-01-10 00:00:00 | 2024-01-10 08:58:58.950897+01
 Infrastructure Services - Uptime     | 100          | 2023-10-01 00:00:00 | 2024-01-10 09:00:38.429033+01
 Infrastructure Services - Uptime     | 100          | 2023-11-01 00:00:00 | 2024-01-10 09:01:31.208777+01
 Infrastructure Services - Uptime     | 100          | 2023-12-01 00:00:00 | 2024-01-10 09:01:39.610051+01
 Platform Services - Uptime           | 100          | 2023-11-01 00:00:00 | 2024-01-10 09:02:34.298399+01
 Platform Services - Uptime           | 100          | 2023-12-01 00:00:00 | 2024-01-10 09:02:42.255531+01
 Toolchain Services - Uptime          | 100          | 2023-11-01 00:00:00 | 2024-01-10 09:05:09.820075+01
 Toolchain Services - Uptime          | 100          | 2023-12-01 00:00:00 | 2024-01-10 09:05:16.518777+01
 Infrastructure Services - Uptime     | 100          | 2023-01-01 00:00:00 | 2024-01-10 09:10:23.772233+01
 Infrastructure Services - Uptime     | 100          | 2023-02-01 00:00:00 | 2024-01-10 09:10:29.233699+01
 Platform Services - Uptime           | 99.98        | 2023-10-01 00:00:00 | 2024-01-10 09:02:21.229743+01
 Toolchain Services - Uptime          | 99.98        | 2023-10-01 00:00:00 | 2024-01-10 09:04:58.316511+01
 Infrastructure Services - Uptime     | 100          | 2024-01-01 00:00:00 | 2024-04-08 12:11:20.948955+02
 Infrastructure Services - Uptime     | 100          | 2024-02-01 00:00:00 | 2024-04-08 12:11:30.695413+02
 Infrastructure Services - Uptime     | 100          | 2024-03-01 00:00:00 | 2024-04-08 12:11:42.459302+02
 Platform Services - Uptime           | 100          | 2024-01-01 00:00:00 | 2024-04-08 12:56:41.542746+02
 Platform Services - Uptime           | 100          | 2024-02-01 00:00:00 | 2024-04-08 12:56:54.227082+02
 Platform Services - Uptime           | 100          | 2024-03-01 00:00:00 | 2024-04-08 12:57:04.571282+02
 Toolchain Services - Uptime          | 100          | 2024-01-01 00:00:00 | 2024-04-08 12:57:19.369375+02
 Toolchain Services - Uptime          | 100          | 2024-02-01 00:00:00 | 2024-04-08 12:57:28.572581+02
 Toolchain Services - Uptime          | 100          | 2024-03-01 00:00:00 | 2024-04-08 12:57:37.552908+02
 SFTP Availability                    | 100          | 2024-01-01 00:00:00 | 2024-04-08 13:54:04.899468+02
 SFTP Availability                    | 100          | 2024-02-01 00:00:00 | 2024-04-08 13:54:15.781852+02
 SFTP Availability                    | 100          | 2024-03-01 00:00:00 | 2024-04-08 13:54:24.196305+02
 Mail Receiver Component Availability | 100          | 2024-01-01 00:00:00 | 2024-04-08 13:54:40.021421+02
 Mail Receiver Component Availability | 100          | 2024-02-01 00:00:00 | 2024-04-08 13:54:50.291186+02
 Mail Receiver Component Availability | 100          | 2024-03-01 00:00:00 | 2024-04-08 13:55:00.424599+02
(62 rows)




INSERT INTO sysengkpi (kpi, availability, date) VALUES
('Toolchain Services - Uptime', 100, '2022-10-01 00:00:00'),
('Infrastructure Services - Uptime', 100, '2022-10-01 00:00:00'),
('Platform Services - Uptime', 100, '2022-10-01 00:00:00', '2023-10-13 11:04:39.85682+02'),
('Toolchain Services - Uptime', 99.72, '2022-11-01 00:00:00', '2023-10-13 14:52:23.740345+02'),
('Toolchain Services - Uptime', 100, '2022-12-01 00:00:00', '2023-10-13 14:52:55.570285+02'),
('Toolchain Services - Uptime', 100, '2023-01-01 00:00:00', '2023-10-13 14:53:21.27241+02'),
('Toolchain Services - Uptime', 100, '2023-02-01 00:00:00', '2023-10-13 14:53:30.619624+02'),
('Toolchain Services - Uptime', 100, '2023-03-01 00:00:00', '2023-10-13 14:53:40.704191+02'),
('Toolchain Services - Uptime', 100, '2023-04-01 00:00:00', '2023-10-13 14:57:51.267562+02'),
('Toolchain Services - Uptime', 100, '2023-05-01 00:00:00', '2023-10-13 14:58:01.529635+02'),
('Toolchain Services - Uptime', 99.58, '2023-09-01 00:00:00', '2023-10-13 14:59:34.603917+02'),
('Toolchain Services - Uptime', 100, '2023-06-01 00:00:00', '2023-10-13 14:58:15.675255+02'),
('Toolchain Services - Uptime', 100, '2023-07-01 00:00:00', '2023-10-13 14:59:07.301122+02'),
('Toolchain Services - Uptime', 100, '2023-08-01 00:00:00', '2023-10-13 14:59:16.755568+02'),
('Infrastructure Services - Uptime', 99.98, '2022-12-01 00:00:00', '2023-10-13 15:04:53.835352+02'),
('Infrastructure Services - Uptime', 100, '2023-01-01 00:00:00', '2023-10-13 15:05:08.821083+02'),
('Infrastructure Services - Uptime', 100, '2023-02-01 00:00:00', '2023-10-13 15:05:20.566444+02'),
('Infrastructure Services - Uptime', 99.99, '2023-03-01 00:00:00', '2023-10-13 15:05:36.860804+02'),
('Infrastructure Services - Uptime', 100, '2023-04-01 00:00:00', '2023-10-13 15:05:50.548783+02'),
('Infrastructure Services - Uptime', 99.98, '2023-05-01 00:00:00', '2023-10-13 15:06:06.750644+02'),
('Infrastructure Services - Uptime', 96.42, '2023-06-01 00:00:00', '2023-10-13 15:06:33.313361+02'),
('Infrastructure Services - Uptime', 99.94, '2023-07-01 00:00:00', '2023-10-13 15:06:50.062272+02'),
('Infrastructure Services - Uptime', 100, '2023-08-01 00:00:00', '2023-10-13 15:07:03.93737+02'),
('Infrastructure Services - Uptime', 99.69, '2023-09-01 00:00:00', '2023-10-13 15:07:20.706449+02'),
('Platform Services - Uptime', 100, '2023-12-01 00:00:00', '2023-10-13 15:09:34.10866+02'),
('Platform Services - Uptime', 100, '2022-12-01 00:00:00', '2023-10-13 15:09:47.279501+02'),
('Platform Services - Uptime', 100, '2023-01-01 00:00:00', '2023-10-13 15:09:57.454767+02'),
('Platform Services - Uptime', 100, '2023-02-01 00:00:00', '2023-10-13 15:10:04.285218+02'),
('Platform Services - Uptime', 100, '2023-03-01 00:00:00', '2023-10-13 15:10:12.20056+02'),
('Platform Services - Uptime', 100, '2023-04-01 00:00:00', '2023-10-13 15:10:18.833608+02'),
('Platform Services - Uptime', 100, '2023-05-01 00:00:00', '2023-10-13 15:10:25.44081+02'),
('Platform Services - Uptime', 100, '2023-06-01 00:00:00', '2023-10-13 15:10:32.095267+02'),
('Platform Services - Uptime', 100, '2023-07-01 00:00:00', '2023-10-13 15:10:38.963114+02'),
('Platform Services - Uptime', 100, '2023-08-01 00:00:00', '2023-10-13 15:10:47.451524+02'),
('Platform Services - Uptime', 100, '2023-09-01 00:00:00', '2023-10-13 15:10:58.036673+02'),
('Infrastructure Services - Uptime', 100, '2023-01-10 00:00:00', '2024-01-10 08:58:58.950897+01'),
('Infrastructure Services - Uptime', 100, '2023-10-01 00:00:00', '2024-01-10 09:00:38.429033+01'),
('Infrastructure Services - Uptime', 100, '2023-11-01 00:00:00', '2024-01-10 09:01:31.208777+01'),
('Infrastructure Services - Uptime', 100, '2023-12-01 00:00:00', '2024-01-10 09:01:39.610051+01'),
('Platform Services - Uptime', 100, '2023-11-01 00:00:00', '2024-01-10 09:02:34.298399+01'),
('Platform Services - Uptime', 100, '2023-12-01 00:00:00', '2024-01-10 09:02:42.255531+01'),
('Toolchain Services - Uptime', 100, '2023-11-01 00:00:00', '2024-01-10 09:05:09.820075+01'),
('Toolchain Services - Uptime', 100, '2023-12-01 00:00:00', '2024-01-10 09:05:16.518777+01'),
('Infrastructure Services - Uptime', 100, '2023-01-01 00:00:00', '2024-01-10 09:10:23.772233+01'),
('Infrastructure Services - Uptime', 100, '2023-02-01 00:00:00', '2024-01-10 09:10:29.233699+01'),
('Platform Services - Uptime', 99.98, '2023-10-01 00:00:00', '2024-01-10 09:02:21.229743+01'),
('Toolchain Services - Uptime', 99.98, '2023-10-01 00:00:00', '2024-01-10 09:04:58.316511+01'),
('Infrastructure Services - Uptime', 100, '2024-01-01 00:00:00', '2024-04-08 12:11:20.948955+02'),
('Infrastructure Services - Uptime', 100, '2024-02-01 00:00:00', '2024-04-08 12:11:30.695413+02'),
('Infrastructure Services - Uptime', 100, '2024-03-01 00:00:00', '2024-04-08 12:11:42.459302+02'),
('Platform Services - Uptime', 100, '2024-01-01 00:00:00', '2024-04-08 12:56:41.542746+02'),
('Platform Services - Uptime', 100, '2024-02-01 00:00:00', '2024-04-08 12:56:54.227082+02'),
('Platform Services - Uptime', 100, '2024-03-01 00:00:00', '2024-04-08 12:57:04.571282+02'),
('Toolchain Services - Uptime', 100, '2024-01-01 00:00:00', '2024-04-08 12:57:19.369375+02'),
('Toolchain Services - Uptime', 100, '2024-02-01 00:00:00', '2024-04-08 12:57:28.572581+02'),
('Toolchain Services - Uptime', 100, '2024-03-01 00:00:00', '2024-04-08 12:57:37.552908+02'),
('SFTP Availability', 100, '2024-01-01 00:00:00', '2024-04-08 13:54:04.899468+02'),
('SFTP Availability', 100, '2024-02-01 00:00:00', '2024-04-08 13:54:15.781852+02'),
('SFTP Availability', 100, '2024-03-01 00:00:00', '2024-04-08 13:54:24.196305+02'),
('Mail Receiver Component Availability', 100, '2024-01-01 00:00:00', '2024-04-08 13:54:40.021421+02'),
('Mail Receiver Component Availability', 100, '2024-02-01 00:00:00', '2024-04-08 13:54:50.291186+02'),
('Mail Receiver Component Availability', 100, '2024-03-01 00:00:00', '2024-04-08 13:55:00.424599+02');


INSERT INTO sysengkpi (kpi, availability, date)
VALUES
('Toolchain Services - Uptime', 100, '2022-10-01 00:00:00'),
('Infrastructure Services - Uptime', 100, '2022-10-02 00:00:00'),
('Platform Services - Uptime', 100, '2022-10-03 00:00:00'),
('Toolchain Services - Uptime', 99.72, '2022-11-01 00:00:00'),
('Toolchain Services - Uptime', 100, '2022-12-01 00:00:00'),
('Toolchain Services - Uptime', 100, '2023-01-01 00:00:00'),
('Toolchain Services - Uptime', 100, '2023-02-01 00:00:00'),
('Toolchain Services - Uptime', 100, '2023-03-01 00:00:00'),
('Toolchain Services - Uptime', 100, '2023-04-01 00:00:00'),
('Toolchain Services - Uptime', 100, '2023-05-01 00:00:00'),
('Toolchain Services - Uptime', 99.58, '2023-09-01 00:00:00'),
('Toolchain Services - Uptime', 100, '2023-06-01 00:00:00'),
('Toolchain Services - Uptime', 100, '2023-07-01 00:00:00'),
('Toolchain Services - Uptime', 100, '2023-08-01 00:00:00'),
('Infrastructure Services - Uptime', 99.98, '2022-12-02 00:00:00'),
('Infrastructure Services - Uptime', 100, '2023-01-01 00:00:00'),
('Infrastructure Services - Uptime', 100, '2023-02-01 00:00:00'),
('Infrastructure Services - Uptime', 99.99, '2023-03-01 00:00:00'),
('Infrastructure Services - Uptime', 100, '2023-04-01 00:00:00'),
('Infrastructure Services - Uptime', 99.98, '2023-05-01 00:00:00'),
('Infrastructure Services - Uptime', 96.42, '2023-06-01 00:00:00'),
('Infrastructure Services - Uptime', 99.94, '2023-07-01 00:00:00'),
('Infrastructure Services - Uptime', 100, '2023-08-01 00:00:00'),
('Infrastructure Services - Uptime', 99.69, '2023-09-01 00:00:00'),
('Platform Services - Uptime', 100, '2023-12-02 00:00:00'),
('Platform Services - Uptime', 100, '2022-12-03 00:00:00'),
('Platform Services - Uptime', 100, '2023-01-01 00:00:01'),
('Platform Services - Uptime', 100, '2023-02-01 00:00:02'),
('Platform Services - Uptime', 100, '2023-03-01 00:00:03'),
('Platform Services - Uptime', 100, '2023-04-01 00:00:04'),
('Platform Services - Uptime', 100, '2023-05-01 00:00:05'),
('Platform Services - Uptime', 100, '2023-06-01 00:00:06'),
('Platform Services - Uptime', 100, '2023-07-01 00:00:07'),
('Platform Services - Uptime', 100, '2023-08-01 00:00:08'),
('Platform Services - Uptime', 100, '2023-09-01 00:00:09'),
('Infrastructure Services - Uptime', 100, '2023-01-10 00:00:11'),
('Infrastructure Services - Uptime', 100, '2023-10-01 00:00:12'),
('Infrastructure Services - Uptime', 100, '2023-11-01 00:00:23'),
('Infrastructure Services - Uptime', 100, '2023-12-01 00:00:13'),
('Platform Services - Uptime', 100, '2023-11-01 00:00:00'),
('Platform Services - Uptime', 100, '2023-12-01 00:00:00'),
('Toolchain Services - Uptime', 100, '2023-11-01 00:00:00'),
('Toolchain Services - Uptime', 100, '2023-12-01 00:00:00'),
('Infrastructure Services - Uptime', 100, '2023-01-01 00:00:00'),
('Infrastructure Services - Uptime', 100, '2023-02-01 00:00:00'),
('Platform Services - Uptime', 99.98, '2023-10-01 00:00:00'),
('Toolchain Services - Uptime', 99.98, '2023-10-01 00:00:00'),
('Infrastructure Services - Uptime', 100, '2024-01-01 00:00:00'),
('Infrastructure Services - Uptime', 100, '2024-02-01 00:00:00'),
('Infrastructure Services - Uptime', 100, '2024-03-01 00:00:00'),
('Platform Services - Uptime', 100, '2024-01-01 00:00:00'),
('Platform Services - Uptime', 100, '2024-02-01 00:00:00'),
('Platform Services - Uptime', 100, '2024-03-01 00:00:00'),
('Toolchain Services - Uptime', 100, '2024-01-01 00:00:00'),
('Toolchain Services - Uptime', 100, '2024-02-01 00:00:00'),
('Toolchain Services - Uptime', 100, '2024-03-01 00:00:00'),
('SFTP Availability', 100, '2024-01-01 00:00:00'),
('SFTP Availability', 100, '2024-02-01 00:00:00'),
('SFTP Availability', 100, '2024-03-01 00:00:00'),
('Mail Receiver Component Availability', 100, '2024-01-01 00:00:00'),
('Mail Receiver Component Availability', 100, '2024-02-01 00:00:00'),
('Mail Receiver Component Availability', 100, '2024-03-01 00:00:00');



INSERT INTO sysengkpi (kpi, availability, date, timestamp) VALUES
('Toolchain Services - Uptime', 100, '2022-10-01 00:00:00', '2023-10-13 14:40:57.735618+02'),
('Infrastructure Services - Uptime', 100, '2022-10-01 00:00:00', '2023-10-13 10:52:54.103479+02'),
('Platform Services - Uptime', 100, '2022-10-01 00:00:00', '2023-10-13 11:04:39.85682+02'),
('Toolchain Services - Uptime', 99.72, '2022-11-01 00:00:00', '2023-10-13 14:52:23.740345+02'),
('Toolchain Services - Uptime', 100, '2022-12-01 00:00:00', '2023-10-13 14:52:55.570285+02'),
('Toolchain Services - Uptime', 100, '2023-01-01 00:00:00', '2023-10-13 14:53:21.27241+02'),
('Toolchain Services - Uptime', 100, '2023-02-01 00:00:00', '2023-10-13 14:53:30.619624+02'),
('Toolchain Services - Uptime', 100, '2023-03-01 00:00:00', '2023-10-13 14:53:40.704191+02'),
('Toolchain Services - Uptime', 100, '2023-04-01 00:00:00', '2023-10-13 14:57:51.267562+02'),
('Toolchain Services - Uptime', 100, '2023-05-01 00:00:00', '2023-10-13 14:58:01.529635+02'),
('Toolchain Services - Uptime', 99.58, '2023-09-01 00:00:00', '2023-10-13 14:59:34.603917+02'),
('Toolchain Services - Uptime', 100, '2023-06-01 00:00:00', '2023-10-13 14:58:15.675255+02'),
('Toolchain Services - Uptime', 100, '2023-07-01 00:00:00', '2023-10-13 14:59:07.301122+02'),
('Toolchain Services - Uptime', 100, '2023-08-01 00:00:00', '2023-10-13 14:59:16.755568+02'),
('Infrastructure Services - Uptime', 99.98, '2022-12-01 00:00:00', '2023-10-13 15:04:53.835352+02'),
('Infrastructure Services - Uptime', 100, '2023-01-01 00:00:00', '2023-10-13 15:05:08.821083+02'),
('Infrastructure Services - Uptime', 100, '2023-02-01 00:00:00', '2023-10-13 15:05:20.566444+02'),
('Infrastructure Services - Uptime', 99.99, '2023-03-01 00:00:00', '2023-10-13 15:05:36.860804+02'),
('Infrastructure Services - Uptime', 100, '2023-04-01 00:00:00', '2023-10-13 15:05:50.548783+02'),
('Infrastructure Services - Uptime', 99.98, '2023-05-01 00:00:00', '2023-10-13 15:06:06.750644+02'),
('Infrastructure Services - Uptime', 96.42, '2023-06-01 00:00:00', '2023-10-13 15:06:33.313361+02'),
('Infrastructure Services - Uptime', 99.94, '2023-07-01 00:00:00', '2023-10-13 15:06:50.062272+02'),
('Infrastructure Services - Uptime', 100, '2023-08-01 00:00:00', '2023-10-13 15:07:03.93737+02'),
('Infrastructure Services - Uptime', 99.69, '2023-09-01 00:00:00', '2023-10-13 15:07:20.706449+02'),
('Platform Services - Uptime', 100, '2023-12-01 00:00:00', '2023-10-13 15:09:34.10866+02'),
('Platform Services - Uptime', 100, '2022-12-01 00:00:00', '2023-10-13 15:09:47.279501+02'),
('Platform Services - Uptime', 100, '2023-01-01 00:00:00', '2023-10-13 15:09:57.454767+02'),
('Platform Services - Uptime', 100, '2023-02-01 00:00:00', '2023-10-13 15:10:04.285218+02'),
('Platform Services - Uptime', 100, '2023-03-01 00:00:00', '2023-10-13 15:10:12.20056+02'),
('Platform Services - Uptime', 100, '2023-04-01 00:00:00', '2023-10-13 15:10:18.833608+02'),
('Platform Services - Uptime', 100, '2023-05-01 00:00:00', '2023-10-13 15:10:25.44081+02'),
('Platform Services - Uptime', 100, '2023-06-01 00:00:00', '2023-10-13 15:10:32.095267+02'),
('Platform Services - Uptime', 100, '2023-07-01 00:00:00', '2023-10-13 15:10:38.963114+02'),
('Platform Services - Uptime', 100, '2023-08-01 00:00:00', '2023-10-13 15:10:47.451524+02'),
('Platform Services - Uptime', 100, '2023-09-01 00:00:00', '2023-10-13 15:10:58.036673+02'),
('Infrastructure Services - Uptime', 100, '2023-01-10 00:00:00', '2024-01-10 08:58:58.950897+01'),
('Infrastructure Services - Uptime', 100, '2023-10-01 00:00:00', '2024-01-10 09:00:38.429033+01'),
('Infrastructure Services - Uptime', 100, '2023-11-01 00:00:00', '2024-01-10 09:01:31.208777+01'),
('Infrastructure Services - Uptime', 100, '2023-12-01 00:00:00', '2024-01-10 09:01:39.610051+01'),
('Platform Services - Uptime', 100, '2023-11-01 00:00:00', '2024-01-10 09:02:34.298399+01'),
('Platform Services - Uptime', 100, '2023-12-01 00:00:00', '2024-01-10 09:02:42.255531+01'),
('Toolchain Services - Uptime', 100, '2023-11-01 00:00:00', '2024-01-10 09:05:09.820075+01'),
('Toolchain Services - Uptime', 100, '2023-12-01 00:00:00', '2024-01-10 09:05:16.518777+01'),
('Infrastructure Services - Uptime', 100, '2023-01-01 00:00:00', '2024-01-10 09:10:23.772233+01'),
('Infrastructure Services - Uptime', 100, '2023-02-01 00:00:00', '2024-01-10 09:10:29.233699+01'),
('Platform Services - Uptime', 99.98, '2023-10-01 00:00:00', '2024-01-10 09:02:21.229743+01'),
('Toolchain Services - Uptime', 99.98, '2023-10-01 00:00:00', '2024-01-10 09:04:58.316511+01'),
('Infrastructure Services - Uptime', 100, '2024-01-01 00:00:00', '2024-04-08 12:11:20.948955+02'),
('Infrastructure Services - Uptime', 100, '2024-02-01 00:00:00', '2024-04-08 12:11:30.695413+02'),
('Infrastructure Services - Uptime', 100, '2024-03-01 00:00:00', '2024-04-08 12:11:42.459302+02'),
('Platform Services - Uptime', 100, '2024-01-01 00:00:00', '2024-04-08 12:56:41.542746+02'),
('Platform Services - Uptime', 100, '2024-02-01 00:00:00', '2024-04-08 12:56:54.227082+02'),
('Platform Services - Uptime', 100, '2024-03-01 00:00:00', '2024-04-08 12:57:04.571282+02'),
('Toolchain Services - Uptime', 100, '2024-01-01 00:00:00', '2024-04-08 12:57:19.369375+02'),
('Toolchain Services - Uptime', 100, '2024-02-01 00:00:00', '2024-04-08 12:57:28.572581+02'),
('Toolchain Services - Uptime', 100, '2024-03-01 00:00:00', '2024-04-08 12:57:37.552908+02'),
('SFTP Availability', 100, '2024-01-01 00:00:00', '2024-04-08 13:54:04.899468+02'),
('SFTP Availability', 100, '2024-02-01 00:00:00', '2024-04-08 13:54:15.781852+02'),
('SFTP Availability', 100, '2024-03-01 00:00:00', '2024-04-08 13:54:24.196305+02'),
('Mail Receiver Component Availability', 100, '2024-01-01 00:00:00', '2024-04-08 13:54:40.021421+02'),
('Mail Receiver Component Availability', 100, '2024-02-01 00:00:00', '2024-04-08 13:54:50.291186+02'),
('Mail Receiver Component Availability', 100, '2024-03-01 00:00:00', '2024-04-08 13:55:00.424599+02');



INSERT INTO sysengkpi (kpi, availability, date) VALUES
('Toolchain Services - Uptime', 100, '2022-10-01 00:00:01'),
('Infrastructure Services - Uptime', 100, '2022-10-01 00:00:02'),
('Platform Services - Uptime', 100, '2022-10-01 00:00:03'),
('Toolchain Services - Uptime', 99.72, '2022-11-01 00:00:01'),
('Toolchain Services - Uptime', 100, '2022-12-01 00:00:01'),
('Toolchain Services - Uptime', 100, '2023-01-01 00:00:01'),
('Toolchain Services - Uptime', 100, '2023-02-01 00:00:04'),
('Toolchain Services - Uptime', 100, '2023-03-01 00:00:01'),
('Toolchain Services - Uptime', 100, '2023-04-01 00:00:01'),
('Toolchain Services - Uptime', 100, '2023-05-01 00:00:01'),
('Toolchain Services - Uptime', 99.58, '2023-09-01 00:00:01'),
('Toolchain Services - Uptime', 100, '2023-06-01 00:00:01'),
('Toolchain Services - Uptime', 100, '2023-07-01 00:00:01'),
('Toolchain Services - Uptime', 100, '2023-08-01 00:00:01'),
('Infrastructure Services - Uptime', 99.98, '2022-12-01 00:00:02'),
('Infrastructure Services - Uptime', 100, '2023-01-01 00:00:02'),
('Infrastructure Services - Uptime', 100, '2023-02-01 00:00:03'),
('Infrastructure Services - Uptime', 99.99, '2023-03-01 00:00:02'),
('Infrastructure Services - Uptime', 100, '2023-04-01 00:00:02'),
('Infrastructure Services - Uptime', 99.98, '2023-05-01 00:00:02'),
('Infrastructure Services - Uptime', 96.42, '2023-06-01 00:00:02'),
('Infrastructure Services - Uptime', 99.94, '2023-07-01 00:00:02'),
('Infrastructure Services - Uptime', 100, '2023-08-01 00:00:02'),
('Infrastructure Services - Uptime', 99.69, '2023-09-01 00:00:02'),
('Platform Services - Uptime', 100, '2023-12-01 00:00:04'),
('Platform Services - Uptime', 100, '2022-12-01 00:00:03'),
('Platform Services - Uptime', 100, '2023-01-01 00:00:03'),
('Platform Services - Uptime', 100, '2023-02-01 00:00:02'),
('Platform Services - Uptime', 100, '2023-03-01 00:00:03'),
('Platform Services - Uptime', 100, '2023-04-01 00:00:03'),
('Platform Services - Uptime', 100, '2023-05-01 00:00:03'),
('Platform Services - Uptime', 100, '2023-06-01 00:00:03'),
('Platform Services - Uptime', 100, '2023-07-01 00:00:03'),
('Platform Services - Uptime', 100, '2023-08-01 00:00:03'),
('Platform Services - Uptime', 100, '2023-09-01 00:00:03'),
('Infrastructure Services - Uptime', 100, '2023-01-10 00:00:01'),
('Infrastructure Services - Uptime', 100, '2023-10-01 00:00:01'),
('Infrastructure Services - Uptime', 100, '2023-11-01 00:00:01'),
('Infrastructure Services - Uptime', 100, '2023-12-01 00:00:01'),
('Platform Services - Uptime', 100, '2023-11-01 00:00:02'),
('Platform Services - Uptime', 100, '2023-12-01 00:00:02'),
('Toolchain Services - Uptime', 100, '2023-11-01 00:00:03'),
('Toolchain Services - Uptime', 100, '2023-12-01 00:00:03'),
('Infrastructure Services - Uptime', 100, '2023-01-01 00:00:04'),
('Infrastructure Services - Uptime', 100, '2023-02-01 00:00:05'),
('Platform Services - Uptime', 99.98, '2023-10-01 00:00:02'),
('Toolchain Services - Uptime', 99.98, '2023-10-01 00:00:03'),
('Infrastructure Services - Uptime', 100, '2024-01-01 00:00:01'),
('Infrastructure Services - Uptime', 100, '2024-02-01 00:00:01'),
('Infrastructure Services - Uptime', 100, '2024-03-01 00:00:01'),
('Platform Services - Uptime', 100, '2024-01-01 00:00:02'),
('Platform Services - Uptime', 100, '2024-02-01 00:00:02'),
('Platform Services - Uptime', 100, '2024-03-01 00:00:02'),
('Toolchain Services - Uptime', 100, '2024-01-01 00:00:03'),
('Toolchain Services - Uptime', 100, '2024-02-01 00:00:03'),
('Toolchain Services - Uptime', 100, '2024-03-01 00:00:03'),
('SFTP Availability', 100, '2024-01-01 00:00:04'),
('SFTP Availability', 100, '2024-02-01 00:00:04'),
('SFTP Availability', 100, '2024-03-01 00:00:04'),
('Mail Receiver Component Availability', 100, '2024-01-01 00:00:05'),
('Mail Receiver Component Availability', 100, '2024-02-01 00:00:05'),
('Mail Receiver Component Availability',100, '2024-03-01 00:00:05');

