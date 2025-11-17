import requests
import csv
from datetime import datetime
import schedule
import time
import os

def collect_efteling_data():
    """Collects Efteling queue data if at least 5 attractions are operating"""
    try:
        # Specify the main endpoint to the Efteling
        entityID = "30713cf6-69a9-47c9-a505-52bb965f01be"  #This is the EFteling id
        url = f"https://api.themeparks.wiki/v1/entity/{entityID}/live"
        response = requests.get(url)
        response.raise_for_status()
        efteling = response.json()
        
        csv_data = []

        # Get timestamp of collecting the data
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        
        # Data should only be collected if the park is open, which is determined with the following code block
        operating_count = 0

        for item in efteling['liveData']:
            if item['entityType'] == 'ATTRACTION':
                if item['status'] == 'OPERATING':
                    operating_count += 1

        if operating_count <= 5:
            return

        # Data collection starts if open attractions are above 5
        for item in efteling['liveData']:
            if item['entityType'] == 'ATTRACTION':
                name = item['name']
                status = item['status']
                standby_wait = item['queue']['STANDBY']['waitTime']
                single_rider_wait = item['queue'].get('SINGLE_RIDER', {}).get('waitTime')
                
                # Handle standby queue
                if status in ['CLOSED', 'DOWN', 'REFURBISHMENT']:
                    standby_wait = 'N/A'
                else:
                    if standby_wait is None:
                        standby_wait = 0
                
                # Add standby queue row
                csv_data.append({
                    'timestamp': timestamp,
                    'attraction_name': name,
                    'status': status,
                    'queue_type': 'STANDBY',
                    'wait_time': standby_wait
                })
                
                # Add single rider queue row if it exists
                if 'SINGLE_RIDER' in item['queue']:
                    if status in ['CLOSED', 'DOWN', 'REFURBISHMENT']:
                        single_rider_wait = 'N/A'
                    else:
                        if single_rider_wait is None:
                            single_rider_wait = 0
                    
                    csv_data.append({
                        'timestamp': timestamp,
                        'attraction_name': name,
                        'status': status,
                        'queue_type': 'SINGLE_RIDER',
                        'wait_time': single_rider_wait
                    })

        # Define CSV filename
        csv_filename = 'efteling_queue_data.csv'

        # Check if file exists to determine if we need to write headers
        file_exists = os.path.isfile(csv_filename)

        # Write to CSV
        with open(csv_filename, 'a', newline='', encoding='utf-8') as csvfile:
            fieldnames = ['timestamp', 'attraction_name', 'status', 'queue_type', 'wait_time']
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            
            # Only write header if file doesn't exist yet
            if not file_exists:
                writer.writeheader()
            
            # Write all rows
            writer.writerows(csv_data)

        print(f"✓ Data collected successfully at {timestamp} ({operating_count} attractions operating)")
        
    except Exception as e:
        print(f"✗ Error collecting data at {datetime.now()}: {str(e)}")

# The api wiki can handle 300 requests. Updating every 5 minutes is recommended so
schedule.every(5).minutes.do(collect_efteling_data)

# Run once immediately when script starts
print("Starting Efteling data collection...")
print("Collecting data every 5 minutes when at least 5 attractions are operating.")
print("Press Ctrl+C to stop.")
collect_efteling_data()

# Keep the script running
while True:
    schedule.run_pending()
    time.sleep(1)