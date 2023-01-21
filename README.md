# Platform Developer I Certification Maintenance (Winter '23)


Updates to Salesforce Platform Developer I Certification Winter 2023.<br>
Hands-On Challenge Solution For `Apex Assertions` <br>
<a href="https://trailhead.salesforce.com/content/learn/modules/platform-developer-i-certification-maintenance-winter-23/" target="_blank">Module Link</a>


<br>

## TestFactory Class

```apex
@isTest
public class TestFactory {
   public static Account getAccount(String accountName, Boolean doInsert) {
       Account account = new Account(Name = accountName);
       if (doInsert) {
           insert account;
       }
       return account;
   }
   public static Contact getContact(Id accountId, String firstName, String lastName, Boolean doInsert){
       Contact contact = new Contact(
           FirstName = firstName,
           LastName = lastName,
           AccountId = accountId
       );
       if (doInsert) {
           insert contact;
       }
       return contact;
   }
   public static void generateAccountWithContacts(Integer numContacts) {
       Account account = getAccount('default account ltd', true);
       List<Contact> contacts = new List<Contact>();
       for (Integer i = 0; i < numContacts; i++) {
           String firstName = 'Contact';
           String lastName = 'Test' + i;
           contacts.add(getContact(account.Id, firstName, lastName, false));
       }
       insert contacts;
   }
}
```
<br>

## DataGenerationTest Class

```apex
@isTest
private class DataGenerationTest {
    @testSetup
    static void dataCreation() {
        Account account = TestFactory.getAccount('Muddy Waters Inc.', true);
        Contact contact = TestFactory.getContact(account.Id, 'Muddy', 'Waters', true);
        Opportunity opp = New Opportunity();
        opp.Name = 'Long lost record';
        opp.AccountId = account.Id;
        opp.CloseDate = Date.today().addDays(14);
        opp.StageName = 'Prospecting';
        insert opp;
    }
    @isTest
    static void testBruteForceAccountCreation() {
        List<Account> accts = new List<Account>();
        Test.startTest();
        accts = [SELECT Id FROM Account];
        Test.stopTest();
        Assert.isTrue(accts.size() > 0, 'Was expecting to find at least one account created on the Test Setup');
    }
    @isTest
    static void testUseTestFactoryToCreateAccountsWithContacts() {
        List<Account> accts;
        List<Contact> contacts;
        TestFactory.generateAccountWithContacts(5);
        Test.startTest();
        accts = [SELECT Id FROM Account];
        contacts = [SELECT Id FROM Contact];
        Test.stopTest();
        Assert.isTrue(accts.size() > 0, 'Was expecting to find at least one account created');
        Assert.isTrue(contacts.size() == 6, 'Was expecting to find 6 contacts');
        Assert.areNotEqual(accts.size(), contacts.size(), 'Was expecting there to be a different number of account and contacts');
    }
    @isTest
    static void testAtTestSetupMethodsRule() {
        List<Opportunity> opps = [SELECT Id, AccountId FROM Opportunity];
        Assert.areEqual(1, opps.size(), 'Expected test to find a single Opp');
    }
}
```
