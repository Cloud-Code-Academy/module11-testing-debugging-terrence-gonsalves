@IsTest
public with sharing class LeadTriggerTest {

    @TestSetup
    static void setUpData() {

        // create test account
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
    
        // create test contact
        Contact testContact = new Contact(FirstName='Test', LastName='Contact', Email='test@example.com', AccountId=testAccount.Id);
        insert testContact;
    }

    /*
    * Test Title of a Lead has been update to Vice President, Manager, Assistant, Executive.
    */
    @IsTest
    static void testHandleTitleNormalization_Insert() {

        // creates leads        
        List<Lead> ldList = new List<Lead>();

        Lead leadVP = new Lead(FirstName = 'Test', LastName = 'Lead', Company = 'Test Company', Title = 'v.p.');
        Lead leadMgr = new Lead(FirstName = 'Test', LastName = 'Lead', Company = 'Test Company', Title = 'manage');
        Lead leadExec = new Lead(FirstName = 'Test', LastName = 'Lead', Company = 'Test Company', Title = 'chief');
        Lead leadAssist = new Lead(FirstName = 'Test', LastName = 'Lead', Company = 'Test Company', Title = 'deputy');

        ldList.add(leadVP);
        ldList.add(leadMgr);
        ldList.add(leadExec);
        ldList.add(leadAssist);

        // perform test
        Test.startTest();
        insert ldList;
        Test.stopTest();

        // get values to check things are working as they should
        List<Lead> ldListCheckVP = [select Id, Title from Lead where Id = :leadVP.Id];
        List<Lead> ldListCheckMgr = [select Id, Title from Lead where Id = :leadMgr.Id];
        List<Lead> ldListCheckExec = [select Id, Title from Lead where Id = :leadExec.Id];
        List<Lead> ldListCheckAssist = [select Id, Title from Lead where Id = :leadAssist.Id];

        // check results
        System.assertEquals('Vice President', ldListCheckVP[0].Title, 'VP Title is not Vice President');
        System.assertEquals('Manager', ldListCheckMgr[0].Title, 'Mgr Title is not Manager');
        System.assertEquals('Executive', ldListCheckExec[0].Title, 'Exec Title is not Executive');
        System.assertEquals('Assistant', ldListCheckAssist[0].Title, 'Assistant Title is not Assistant');
    }

    /*
    * Test updating the titles to make sure the before update trigger fires and test pass.
    */
    @IsTest
    static void testHandleTitleNormalization_Update() {

        // creates leads        
        List<Lead> ldList = new List<Lead>();

        Lead leadVP = new Lead(FirstName='Test', LastName='Lead', Company='Test Company', Title='v.p.');
        Lead leadMgr = new Lead(FirstName='Test', LastName='Lead', Company='Test Company', Title='manage');
        Lead leadExec = new Lead(FirstName='Test', LastName='Lead', Company='Test Company', Title='chief');
        Lead leadAssist = new Lead(FirstName='Test', LastName='Lead', Company='Test Company', Title='deputy');

        ldList.add(leadVP);
        ldList.add(leadMgr);
        ldList.add(leadExec);
        ldList.add(leadAssist);

        insert ldList;

        // get values to check things are working as they should
        List<Lead> updatedLeads = new List<Lead>();

        List<Lead> ldListCheckVP = [select Id, Title from Lead where Id = :leadVP.Id];
        List<Lead> ldListCheckMgr = [select Id, Title from Lead where Id = :leadMgr.Id];
        List<Lead> ldListCheckExec = [select Id, Title from Lead where Id = :leadExec.Id];
        List<Lead> ldListCheckAssist = [select Id, Title from Lead where Id = :leadAssist.Id];
        
        ldListCheckVP[0].Title = 'vp';
        ldListCheckMgr[0].Title = 'mgr';
        ldListCheckExec[0].Title = 'exec';
        ldListCheckAssist[0].Title = 'assist';
       
        updatedLeads.add(ldListCheckVP[0]);
        updatedLeads.add(ldListCheckMgr[0]);
        updatedLeads.add(ldListCheckExec[0]);
        updatedLeads.add(ldListCheckAssist[0]);

        // perform test
        Test.startTest();
        update updatedLeads;
        Test.stopTest();

        // grab values to check
        List<Lead> ldListCheckVPUpdated = [select Id, Title from Lead where Id = :leadVP.Id];
        List<Lead> ldListCheckMgrUpdated = [select Id, Title from Lead where Id = :leadMgr.Id];
        List<Lead> ldListCheckExecUpdated = [select Id, Title from Lead where Id = :leadExec.Id];
        List<Lead> ldListCheckAssistUpdated = [select Id, Title from Lead where Id = :leadAssist.Id];

        // check results
        System.assertEquals('Vice President', ldListCheckVPUpdated[0].Title, 'VP Title is not Vice President');
        System.assertEquals('Manager', ldListCheckMgrUpdated[0].Title, 'Mgr Title is not Manager');
        System.assertEquals('Executive', ldListCheckExecUpdated[0].Title, 'Exec Title is not Executive');
        System.assertEquals('Assistant', ldListCheckAssistUpdated[0].Title, 'Assist Title is not Assistant');
    }

    /*
    * Test inserting various fields to increment scores.
    */
    @IsTest
    static void testHandleAutoLeadScoring_Insert() {

        // create 3 differing Leads to test all if statements/scores
        List<Lead> ldList = new List<Lead>();

        Lead ldA = new Lead(
            FirstName='Test', 
            LastName='Lead', 
            Company='Test Company', 
            LeadSource='Website', 
            Email='test@gmail.com', 
            Phone='1234567890'); // 8        
        Lead ldB = new Lead(
            FirstName='Test', 
            LastName='Lead', 
            Company='Test Company', 
            Industry='Technology', 
            Phone='123-456-7890'); // 15
        Lead ldC = new Lead(
            FirstName='Test', 
            LastName='Lead', 
            Company='Test Company', 
            LeadSource='Website', 
            Email='test@gmail.com', 
            Phone='1234567890', 
            Industry='Technology'); // 18
        Lead ldD = new Lead(FirstName='Test', LastName='Lead', Company='Test Company'); // 0

        ldList.add(ldA);
        ldList.add(ldB);
        ldList.add(ldC);
        ldList.add(ldD);

        // perform test
        Test.startTest();
        insert ldList;
        Test.stopTest();

        // grab Leads to test scores
        List<Lead> ldListCheckA = [select Id, Lead_Score__c from Lead where Id = :ldA.Id];
        List<Lead> ldListCheckB = [select Id, Lead_Score__c from Lead where Id = :ldB.Id];
        List<Lead> ldListCheckC = [select Id, Lead_Score__c from Lead where Id = :ldC.Id];
        List<Lead> ldListCheckD = [select Id, Lead_Score__c from Lead where Id = :ldD.Id];

        System.assertEquals(8, ldListCheckA[0].Lead_Score__c, 'Lead Score should be equal to 8');
        System.assertEquals(15, ldListCheckB[0].Lead_Score__c, 'Lead Score should be equal to 15');
        System.assertEquals(18, ldListCheckC[0].Lead_Score__c, 'Lead Score should be equal to 18');
        System.assertEquals(0, ldListCheckD[0].Lead_Score__c, 'Lead Score should be equal to 0');
    }

    /*
    * Test updating scores by changing various fields.
    */
    @IsTest
    static void testHandleAutoLeadScoring_Update() {

        // create 3 differing Leads to test all if statements/scores
        List<Lead> ldList = new List<Lead>();

        Lead ldA = new Lead(
            FirstName='Test', 
            LastName='Lead', 
            Company='Test Company', 
            LeadSource='Website', 
            Email='test@gmail.com', 
            Phone='1234567890'); // 8        
        Lead ldB = new Lead(
            FirstName='Test', 
            LastName='Lead', 
            Company='Test Company', 
            Industry='Technology', 
            Phone='123-456-7890'); // 15
        Lead ldC = new Lead(
            FirstName='Test', 
            LastName='Lead', 
            Company='Test Company', 
            LeadSource='Website', 
            Email='test@gmail.com', 
            Phone='1234567890', 
            Industry='Technology'); // 18
        Lead ldD = new Lead(FirstName='Test', LastName='Lead', Company='Test Company'); // 0

        ldList.add(ldA);
        ldList.add(ldB);
        ldList.add(ldC);
        ldList.add(ldD);

        insert ldList;

        List<Lead> updatedLeads = new List<Lead>();

        List<Lead> ldListCheckA = [select Id, Lead_Score__c from Lead where Id = :ldA.Id];
        List<Lead> ldListCheckB = [select Id, Lead_Score__c from Lead where Id = :ldB.Id];
        List<Lead> ldListCheckC = [select Id, Lead_Score__c from Lead where Id = :ldC.Id];
        List<Lead> ldListCheckD = [select Id, Lead_Score__c from Lead where Id = :ldD.Id];
        
        ldListCheckA[0].LeadSource = 'Email'; // 5

        ldListCheckB[0].LeadSource='Website'; 
        ldListCheckB[0].Email='test@gmail.com'; // 18

        ldListCheckC[0].LeadSource=''; 
        ldListCheckC[0].Email='test@gmail.com';
        ldListCheckC[0].Phone=null;
        ldListCheckC[0].Industry=''; // 0

        ldListCheckD[0].Lead_Score__c = 22; // 18

        updatedLeads.add(ldListCheckA[0]);
        updatedLeads.add(ldListCheckB[0]);
        updatedLeads.add(ldListCheckC[0]);
        updatedLeads.add(ldListCheckD[0]);

        // perform test
        Test.startTest();
        update updatedLeads;
        Test.stopTest();

        // grab Leads to test scores
        List<Lead> ldListCheckAUpdated = [select Id, Lead_Score__c from Lead where Id = :ldA.Id];
        List<Lead> ldListCheckBUpdated = [select Id, Lead_Score__c from Lead where Id = :ldB.Id];
        List<Lead> ldListCheckCUpdated = [select Id, Lead_Score__c from Lead where Id = :ldC.Id];
        List<Lead> ldListCheckDUpdated = [select Id, Lead_Score__c from Lead where Id = :ldD.Id];

        System.assertEquals(5, ldListCheckAUpdated[0].Lead_Score__c, 'Lead Score should be equal to 5 actual is ' + ldListCheckAUpdated[0].Lead_Score__c);
        System.assertEquals(18, ldListCheckBUpdated[0].Lead_Score__c, 'Lead Score should be equal to 18 actual is ' + ldListCheckBUpdated[0].Lead_Score__c);
        System.assertEquals(0, ldListCheckCUpdated[0].Lead_Score__c, 'Lead Score should be equal to 0 actual is ' + ldListCheckCUpdated[0].Lead_Score__c);
        System.assertEquals(18, ldListCheckDUpdated[0].Lead_Score__c, 'Lead Score should be equal to 18 actual is ' + ldListCheckDUpdated[0].Lead_Score__c);
    }

    @IsTest
    static void testHandleLeadAutoConvert_Insert() {

        // test lead auto-convert on insert
        Lead testLead = new Lead(FirstName='Test', LastName='Lead', Company='Test Company', Email='test@example.com');
        
        Test.startTest();
        insert testLead;
        Test.stopTest(); 
        
        // verify lead is auto-converted
        Lead convertedLead = [select Id, IsConverted, ConvertedContactId from Lead where Id = :testLead.Id];
        System.assert(convertedLead.IsConverted, 'Lead should be converted');
    }

    @isTest
    static void testHandleLeadAutoConvert_Update() {

        // test lead auto-convert on email update
        Lead testLead = new Lead(FirstName='Test', LastName='Lead', Company='Test Company', Email='newlead@example.com');
        insert testLead;
        
        testLead.Email = 'test@example.com';
        
        Test.startTest();
        Database.DMLOptions dml = new Database.DMLOptions(); 
        dml.DuplicateRuleHeader.allowSave = true;
        dml.DuplicateRuleHeader.runAsCurrentUser = true;
        Database.update(testLead, dml);
        Test.stopTest();
        
        // verify lead conversion
        Lead convertedLead = [select Id, IsConverted, ConvertedContactId from Lead where Id = :testLead.Id];
        System.assert(convertedLead.IsConverted, 'Lead should be converted after email update');
    }

    @isTest
    static void testHandleLeadAutoConvert_MultipleContacts() {

        // create another contact with the same email
        Contact anotherContact = new Contact(FirstName='Another', LastName='Contact', Email='test@example.com');
        insert anotherContact;

        Lead testLead = new Lead(FirstName='Test', LastName='Lead', Company='Test Company', Email='test@example.com');

        Test.startTest();
        insert testLead;
        Test.stopTest();

        // verify lead is not converted
        Lead unconvertedLead = [select Id, IsConverted from Lead where Id = :testLead.Id];
        System.assert(!unconvertedLead.IsConverted, 'Lead should not be converted');
    }

    @isTest
    static void testHandleLeadAutoConvert_NoMatchingContact() {

        // create Lead
        Lead testLead = new Lead(FirstName='Test', LastName='Lead', Company='Test Company', Email='notMatch@example.com');

        Test.startTest();
        insert testLead;
        Test.stopTest();

        // verify lead is not converted
        Lead unconvertedLead = [select Id, IsConverted from Lead where Id = :testLead.Id];
        System.assert(!unconvertedLead.IsConverted, 'Lead should not be converted when no matching contact exists');
    }
}