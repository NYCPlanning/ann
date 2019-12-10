import psycopg2
import csv
import os

# A second version of the script to determine if a lot if regular or not. This version will check only for
# polygons with more than 4 angles, rather than looking at whether an angle is right or not.

def get_angle(bbl_hold, path_1_1_hold, path_1_2_hold, path_1_3_hold, path_2_1_hold, path_2_2_hold, path_2_3_hold, path_3_1_hold, path_3_2_hold, path_3_3_hold):
    select_table_query = "SELECT 360 - degrees(ST_Angle(ST_SetSRID(p1.geom, 2263), ST_SetSRID(p2.geom, 2263), ST_SetSRID(p3.geom, 2263))) FROM dcp.pluto_points p1, dcp.pluto_points p2, dcp.pluto_points p3 WHERE p1.bbl = '" + str(bbl_hold) + "' AND p1.bbl = p2.bbl AND p2.bbl = p3.bbl AND p1.path_1 = " + str(path_1_1_hold) + " AND p1.path_2 = " + str(path_1_2_hold) + " AND p1.path_3 = " + str(path_1_3_hold) + " AND p2.path_1 = " + str(path_2_1_hold) + " AND p2.path_2 = " + str(path_2_2_hold) + " AND p2.path_3 = " + str(path_2_3_hold) + " AND p3.path_1 = " + str(path_3_1_hold) + " AND p3.path_2 = " + str(path_3_2_hold) + " AND p3.path_3 = " + str(path_3_3_hold) + ";"
    cursor.execute(select_table_query)
    angle = cursor.fetchall()
    if angle[0][0]:
        angle_list.append(angle[0][0])
    else:
        print("Angle is null ", str(bbl_hold), str(path_1_1_hold), str(path_1_2_hold), str(path_1_3_hold),
        str(path_2_1_hold), str(path_2_2_hold), str(path_2_3_hold),str(path_3_1_hold), str(path_3_2_hold), str(path_3_3_hold))

def evaluate_angles(angle_list):
    angle_count = 0
    for angle in angle_list:
        if angle >= 160 and angle <= 200:
            continue
        else:
            angle_count += 1

    if angle_count > 4:
        irregular_writer.writerow([bbl_hold,"","","","","","",""])
        return "irregular"
    else:
        regular_writer.writerow([bbl_hold,"","","","","","",""])
        return "regular"

def setup_last_angle(angle_list, path_2_1_hold, path_2_2_hold, path_2_3_hold):
    path_1_1_hold = path_2_1_hold
    path_1_2_hold = path_2_2_hold
    path_1_3_hold = path_2_3_hold
    path_2_1_hold = 1
    path_2_2_hold = 1
    path_2_3_hold = 1
    path_3_1_hold = 1
    path_3_2_hold = 1
    path_3_3_hold = 2
    return last_angle(angle_list, bbl_hold, path_1_1_hold, path_1_2_hold, path_1_3_hold, path_2_1_hold, path_2_2_hold, path_2_3_hold, path_3_1_hold, path_3_2_hold, path_3_3_hold)

def last_angle(angle_list, bbl_hold, path_1_1_hold, path_1_2_hold, path_1_3_hold, path_2_1_hold, path_2_2_hold, path_2_3_hold, path_3_1_hold, path_3_2_hold, path_3_3_hold):
    get_angle(bbl_hold, path_1_1_hold, path_1_2_hold, path_1_3_hold, path_2_1_hold, path_2_2_hold, path_2_3_hold, path_3_1_hold, path_3_2_hold, path_3_3_hold)
    angle_list.sort(reverse=True)
    result = evaluate_angles(angle_list)
    return result

try:
    connection = psycopg2.connect(user = "postgres",
                                  password = "aem2420!",
                                  host = "127.0.0.1",
                                  port = "5432",
                                  database = "postgres")

    cursor = connection.cursor()

    select_table_query = "SELECT bbl, path_1, path_2, path_3 FROM dcp.pluto_points WHERE path_1 = 1 AND path_2 = 1 ORDER BY bbl, path_1, path_2, path_3;"
    cursor.execute(select_table_query)
    print("Selecting points from pluto 19.1 table using cursor.fetchall")
    pluto_records = cursor.fetchall()
    read_count = bbl_read_count = regular_count = irregular_count = 0
    angle_list = []
    bbl_hold = 0
    path_1_1_hold = path_1_2_hold = path_1_3_hold = path_2_1_hold = path_2_2_hold = path_2_3_hold = path_3_1_hold = path_3_2_hold = path_3_3_hold = 0
    script_dir = os.path.dirname(__file__)  # Script directory
    regular_full_path = os.path.join(script_dir, '../output/regular_angles.csv')
    irregular_full_path = os.path.join(script_dir, '../output/irregular_angles.csv')

    with open(regular_full_path, mode='w', newline='') as regular:
        with open(irregular_full_path, mode="w", newline='') as irregular:
            regular_writer = csv.writer(regular, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
            irregular_writer = csv.writer(irregular, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

            for row in pluto_records:

                read_count+=1
                if read_count % 1000 == 0:
                    print('Records read: ', str(read_count))
                if read_count == 1:
                    bbl_hold = row[0]

                if row[0] == bbl_hold:
                    path_1_1_hold = path_2_1_hold
                    path_1_2_hold = path_2_2_hold
                    path_1_3_hold = path_2_3_hold
                    path_2_1_hold = path_3_1_hold
                    path_2_2_hold = path_3_2_hold
                    path_2_3_hold = path_3_3_hold
                    path_3_1_hold = row[1]
                    path_3_2_hold = row[2]
                    path_3_3_hold = row[3]
                    bbl_hold = row[0]
                    bbl_read_count+=1

                    if bbl_read_count >= 3:
                        get_angle(bbl_hold, path_1_1_hold, path_1_2_hold, path_1_3_hold, path_2_1_hold, path_2_2_hold, path_2_3_hold, path_3_1_hold, path_3_2_hold, path_3_3_hold)

                    continue
                        # Think about what to do with angles that aren't valid.

                # Closing angle
                result = setup_last_angle(angle_list, path_2_1_hold, path_2_2_hold, path_2_3_hold)
                if result == "regular":
                    regular_count+=1
                else:
                    irregular_count+=1

                angle_list = []
                right_angle_count = 0
                bbl_read_count = 1
                path_3_1_hold = row[1]
                path_3_2_hold = row[2]
                path_3_3_hold = row[3]
                path_1_1_hold = path_1_2_hold = path_1_3_hold = path_2_1_hold = path_2_2_hold = path_2_3_hold = 0
                bbl_hold = row[0]

            # EOF
            result = setup_last_angle(angle_list, path_2_1_hold, path_2_2_hold, path_2_3_hold)
            if result == "regular":
                regular_count+=1
            else:
                irregular_count+=1

    print("Pluto 19.1 point records read ", read_count)
    print("Regular polygons: ", regular_count)
    print("Irregular polygons: ", irregular_count)

except (Exception, psycopg2.Error) as error:
    print("Error while fetching data from PostgreSQL", error)
    print("BBL was ", str(bbl_hold))
finally:
    if (connection):
        cursor.close()
        connection.close()
        print("PostgreSQL connection is closed")
