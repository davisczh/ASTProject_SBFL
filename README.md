1. **Install Docker**

   - Ensure Docker is installed on your machine.

2. **Run Build Container Script**

   - Execute the script to build your Docker container:
     ```bash
     bash buildcontainer.sh
     ```

3. **Start the Container**

   - Run the following command to start your Docker container:
     ```bash
     bash startcontainer.sh
     ```
   - You should now be inside the container.

4. **Edit the Run Script**

   - Use `nano` to edit the `run.sh` script located at `/src/run.sh`:
     ```bash
     nano /src/run.sh
     ```
   - Make the following edits:
     - Set `PID="Lang"`
     - Set `BID="5"`
     - In the last command, choose which formula to use by editing:
       ```bash
       --formula "ochiai"
       ```
   - Save your changes by pressing `CTRL + X`, then press `Y` when prompted.

5. **Execute the Run Script**

   - Run the modified script:
     ```bash
     cd /src
     bash run.sh
     ```
   - After execution, a new folder should appear in `/workdir`.

6. **Check Generated Reports**
   - Navigate to the `/sfl` directory inside the newly created folder to view the generated reports:
     ```bash
     cd /workdir/<new_folder>/sfl
     ```
   - This directory will contain the Spectrum-Based Fault Localization (SBFL) reports.

**Note:** `defects4j` and `gzoltar` should always be there by default after you run `run.sh` for the first time.

7. Create failing tests file
   - Creates a `failing_test` file within the faults folder within Lang-5b folder.
   - It will be used to check for the accuracy of the fault localisation.

8. Prepare Docker for `pandas` library

**Execute these in the Docker Desktop:**
```bash
apt update && apt install -y python3-pip
```

```bash
apt install -y python3-pip
```

```bash
pip install pandas
```


