# enterprise-counters

To overcome the limitations of naive implementations like [OpenZeppelin's Counters](https://docs.openzeppelin.com/contracts/4.x/api/utils#Counters), we are proud to introduce *Enterprise Counters*:

- no hardcoded dependencies thanks to on-chain Inversion-of-Control (IoC) containers
- use the default increment with built-in retries or implement your own
- flexible XML-based configuration
- swappable storage backends
- a powerful logging module
- modular access control
- easy to mock

Ready to try? Read on!

## Usage

For a basic setup, see [IntegrationTest.sol](https://github.com/karmacoma-eth/enterprise-counters/blob/main/test/IntegrationTest.sol):

```solidity
    XmlConfig config;
    EnterpriseCounter counter;

    function setUp() public {
        config = new XmlConfig();

        // given a proper config
        string memory configXml = string(abi.encodePacked(
            "<?xml version='1.0' encoding='UTF-8'?>",
            "<beans>",
                "<bean id=\"EnterpriseCounter\" class=\"ProductionReadyCounter\"/>",
                "<bean id=\"SecurityManager\" class=\"StrictSecurityManager\"/>",
                "<bean id=\"Logger\" class=\"EventLogger\"/>",
            "</beans>"
        ));
        Injector injector = config.load(configXml);

        SecurityManager securityManager = SecurityManager(injector.getSingleton("SecurityManager"));
        securityManager.grantRole(securityManager.INCREMENTER_ROLE(), address(this));
        securityManager.grantRole(securityManager.READER_ROLE(), address(this));

        counter = EnterpriseCounter(injector.getSingleton("EnterpriseCounter"));
    }
```

After this seamless setup, we can now call `counter.increment()` and get the expected value with `counter.get()`


## Licensing

Please contact sales@enterprise-counters.com to get a quote.
