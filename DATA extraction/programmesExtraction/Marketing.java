import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.StringTokenizer;

import oracle.kv.FaultException;
import oracle.kv.KVStore;
import oracle.kv.KVStoreConfig;
import oracle.kv.KVStoreFactory;
import oracle.kv.StatementResult;
import oracle.kv.table.Row;
import oracle.kv.table.Table;
import oracle.kv.table.TableAPI;

public class Marketing {
    private final KVStore store;

    public static void main(String args[]) {
        try {
            Marketing arb = new Marketing(args);
            arb.initMarketingTablesAndData(arb);

        } catch (RuntimeException e) {
            e.printStackTrace();
        }
    }

    Marketing(String[] argv) {

        String storeName = "kvstore";
        String hostName = "localhost";
        String hostPort = "5000";
        final int nArgs = argv.length;
        int argc = 0;

        store = KVStoreFactory.getStore(new KVStoreConfig(storeName, hostName + ":" + hostPort));
    }

    public void initMarketingTablesAndData(Marketing arb) {
        arb.dropTableMarketing();
        arb.createTableMarketing();
        arb.loadMarketingDataFromFile("./Marketing.txt");
    }

    public void dropTableMarketing() {
        String statement = null;
        statement = "drop table Marketing";
        executeDDL(statement);
    }

    public void createTableMarketing() {
        String statement = null;
        statement = "create table Marketing ("   
                + "MARKETINGID INTEGER,"           
                + "AGE INTEGER,"
                + "SEXE STRING,"
                + "TAUX INTEGER,"
                + "SITUATION_FAMILIALE STRING,"
                + "NBR_ENFANT INTEGER,"
                + "VOITURE_2 STRING,"
                + "PRIMARY KEY(MARKETINGID))";
        executeDDL(statement);

    }

    void loadMarketingDataFromFile(String marketingDataFileName) {
        InputStreamReader ipsr;
        BufferedReader br = null;
        InputStream ips;
        String ligne;

        System.out.println("Loading Marketing ...");

        try {
            ips = new FileInputStream(marketingDataFileName);
            ipsr = new InputStreamReader(ips);
            br = new BufferedReader(ipsr);
            while ((ligne = br.readLine()) != null) {
                ArrayList<String> marketingRecord = new ArrayList<String>();
                StringTokenizer val = new StringTokenizer(ligne, ",");
                while (val.hasMoreTokens()) {
                    marketingRecord.add(val.nextToken().toString());
                }
            
                int marketingid = Integer.parseInt(marketingRecord.get(0));
                int age = Integer.parseInt(marketingRecord.get(1));
                String sexe = marketingRecord.get(2);
                int taux = Integer.parseInt(marketingRecord.get(3));
                String SFamiliale = marketingRecord.get(4);
                int nbEnfantsAcharge = Integer.parseInt(marketingRecord.get(5));
                String voiture_2 = marketingRecord.get(6);
                // Add the marketing in the KVStore
                this.insertAmarketingRow(marketingid, age, sexe, taux, SFamiliale, nbEnfantsAcharge, voiture_2 );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void insertAmarketingRow(int marketingid, int age, String sexe, int taux, String SFamiliale, int nbEnfantsAcharge,
            String voiture_2) {
        // TableAPI tableAPI = store.getTableAPI();
        StatementResult result = null;
        String statement = null;
        try {

            TableAPI tableH = store.getTableAPI();
            Table tablemarketing = tableH.getTable("Marketing");

            Row marketingRow = tablemarketing.createRow();

            marketingRow.put("MARKETINGID", marketingid);
            marketingRow.put("AGE", age);
            marketingRow.put("SEXE", sexe);
            marketingRow.put("TAUX", taux);
            marketingRow.put("SITUATION_FAMILIALE", SFamiliale);
            marketingRow.put("NBR_ENFANT", nbEnfantsAcharge);
            marketingRow.put("VOITURE_2", voiture_2);
            tableH.put(marketingRow, null, null);

        } catch (IllegalArgumentException e) {
            System.out.println("Invalid statement:\n" + e.getMessage());
        } catch (FaultException e) {
            System.out.println("Statement couldn't be executed, please retry: " + e);
        }
    }

    public void executeDDL(String statement) {
        TableAPI tableAPI = store.getTableAPI();
        StatementResult result = null;
        try {
            result = store.executeSync(statement);
        } catch (IllegalArgumentException e) {
            System.out.println("Invalid statement:\n" + e.getMessage());
        } catch (FaultException e) {
            System.out.println("Statement couldn't be executed, please retry: " + e);
        }
    }
}
// CREATE EXTERNAL TABLE IF NOT EXISTS Marketing (
// ClIENTID INTEGER,
// AGE INTEGER,
// SEXE STRING,
// TAUX INTEGER,
// SITUATION_FAMILIALE STRING,
// NBR_ENFANT INTEGER,
// VOITURE_2 STRING,
// IMMATRICULATION STRING,
// PRIMARY KEY(ClIENTID)
// )
// STORED BY 'oracle.kv.hadoop.hive.table.TableStorageHandler'
// TBLPROPERTIES (
// "oracle.kv.kvstore" = "kvstore",
// "oracle.kv.hosts" = "localhost:5000",
// "oracle.kv.tableName" = "vehicleTable"
// );
