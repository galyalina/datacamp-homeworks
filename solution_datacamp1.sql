-- #Question 3: Count records *

SELECT
    count(*)
FROM
	yellow_taxi_data
WHERE 
	    EXTRACT(MONTH FROM tpep_pickup_datetime) = 1 
    AND 
        EXTRACT(DAY FROM tpep_pickup_datetime) = 15

-- #Question 4: Largest tip for each day *

SELECT 
    to_char(tpep_pickup_datetime, 'YYYY-MM-dd') 
FROM 
    yellow_taxi_data 
WHERE 
    EXTRACT(MONTH FROM tpep_pickup_datetime) = 1
GROUP BY
    tpep_pickup_datetime ORDER BY max(tip_amount) DESC LIMIT 1

-- Question 5: Most popular destination *

SELECT 
	t3."Zone"
FROM
	(SELECT 
	 	count(*) as total_trips, "PULocationID" as pickup , "DOLocationID" as dropoff 
	 FROM 
	 	yellow_taxi_data 
	WHERE 
			EXTRACT(MONTH FROM tpep_pickup_datetime) = 1 
		AND 
	 		EXTRACT(DAY FROM tpep_pickup_datetime) = 14
	GROUP BY pickup, dropoff)t1
	LEFT JOIN 
		zone_lookup_data t2
	ON t1.pickup=t2."LocationID" 
	LEFT JOIN 
		zone_lookup_data t3
	ON t1.dropoff=t3."LocationID" 
WHERE t2."Zone" ilike 'central park'
ORDER BY total_trips DESC
LIMIT 1

-- #Question 6: Most expensive route *

SELECT 
	coalesce(t2."Zone", 'Unknown'), coalesce(t3."Zone", 'Unknown')
FROM
	(SELECT 
        avg(price) AS biggest_avg, pickup, dropoff
	FROM
		(SELECT 
			"PULocationID" AS pickup,
			"DOLocationID" AS dropoff,
			total_amount AS price
		FROM 
			public.yellow_taxi_data) t_rides
	GROUP BY 
        pickup, dropoff
	ORDER BY 
        biggest_avg 
    DESC LIMIT 1) t1,
	zone_lookup_data t2,
	zone_lookup_data t3
WHERE
	t1.pickup = t2."LocationID"
	AND
	t1.dropoff = t3."LocationID"