# AST SBFL Project

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
4. **Execute the Run Script**

   - Run the script:
     ```bash
     cd /src
     bash run_withsplit.sh
     ```
   - After execution, a new folder should appear in `/workdir`.

5. **Check Generated Reports**
   - Navigate to the `/sfl` directory inside the newly created folder to view the generated reports:

   **For Pre-Split SBFL Reports**
   ```bash
   cd /workdir/<new_folder>/sfl/txt
   ```

   **For Post-Split SBFL Reports**
   ```bash
   cd /workdir/<new_folder>/report_part{part no}/sfl/txt
   ```
      - These directories will contain the Spectrum-Based Fault Localization (SBFL) reports.

   **Note:** `defects4j` and `gzoltar` should always be there by default after you run `run.sh` for the first time.

6. Create failing tests file by running `create_failing.sh`

```bash
bash create_failing.sh
```
   - Creates a `failing_test` file within the faults folder within Lang-5b (could be 6b or 7b also) folder.
   - It will be used to check for the accuracy of the fault localisation.


7. Run `evalUnifiedSFL.py` to get an output log to confirm the hypothesis.

```bash
python3 evalUnifiedSFL.py
```
