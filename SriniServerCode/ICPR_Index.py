import numpy as np
import scipy.misc



def ICPR_NameGenerator(SerialNo):
    Name = ['A','0','A','_','0','A'];
    if SerialNo >= 50:
        Name[0] = 'H';
        SerialNo = SerialNo - 50;
    Folder = np.floor(SerialNo/10);    
    Name[2] = str(np.int(Folder))
    File = SerialNo - Folder * 10;
    Name[5] = str(np.int(File));
    Name = ''.join(Name);
    return Name