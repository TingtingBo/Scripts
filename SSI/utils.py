import os

# Read one line in the file generated by record_time.py
def load_time(filename):
    time_file = open(filename, "r")
    time = time_file.readline()
    time_file.close()
    return float(time)

# Write the header file, I've put it here as we don't need to parse XTML when reading the to_stream code
def write_header(header_file, sample_rate, t_now, t_utc, num_row):
    tab = "\t" # for readability
    header_file.write("<?xml version=\"1.0\" ?>\n")
    header_file.write("<stream ssi-v=\"2\">\n")
    header_file.write(tab + "<info ftype=\"ASCII\" sr=\"" + str(sample_rate) + "\" dim=\"1\" byte=\"4\" type=\"FLOAT\" delim=\";\" />\n")
    header_file.write(tab + "<meta />\n") # Not sure why we need this XML tag?
    header_file.write(tab + "<time ms=\"0\" local=\"" + t_now + "\" system=\"" + t_utc + "\"/>\n")
    header_file.write(tab + "<chunk from=\"0.000000\" to=\"" + str(num_row/sample_rate) + "\" byte=\"0\" num=\"" + str(num_row) + "\"/>\n")
    header_file.write("</stream>\n")

class Participant:
    def __init__(self,p_id,tps_name,saving_path):
        self.id = p_id
        self.tps_name = tps_name
        self.saving_path = saving_path

        self.position = None

    def set_position(self,position):
        self.position = position

class Experiment:
    def __init__(self,experiment_info, output_path):
        self.experiment_info = experiment_info
        self.output_path = output_path 
        self.num_participant = int(experiment_info["num_participant"])
        self.session_name = experiment_info["session"]
        self.participants = []

        # Iterate over each participant and create them
        # also create their saving path
        for i in range(0,self.num_participant):
            p_id = "P"+str(i+1)
            tps_name = self.experiment_info[p_id]

            # If the participant is not absent then we 
            if tps_name != "ABSENT":
                participant_path = os.path.join(output_path,p_id)
                saving_path = os.path.join(participant_path,self.session_name)

                # create the participant
                self.participants.append(Participant(p_id,tps_name,saving_path))
                if not os.path.exists(participant_path):
                    # create the base directory
                    os.mkdir(participant_path)
                    
                    # create the session path
                    saving_path = os.path.join(participant_path,self.session_name)
                    os.mkdir(saving_path)

    # This will get a participant based on the tps_name
    def get_participant(self, tps_name):

        for participant in self.participants:
            #print(participant.tps_name)
            if participant.tps_name == tps_name:
                return participant
        
        return None
