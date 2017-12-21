pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../../contracts/lib/AddressSet.sol";

contract TestAddressSet {
    using AddressSet for AddressSet.SetData;

    function testTwoItems() public {
        AddressSet.SetData storage set;

        address testData1 = address(1);
        address testData2 = address(2);
        address notIncluded = address(3);

        Assert.equal(set.size(), 0, "expected size of 0 before adding");
        set.put(testData1);
        Assert.equal(set.size(), 1, "expected size of 1 before adding");
        set.put(testData2);
        Assert.equal(set.size(), 2, "expected size of 2");

        // duplicate insert
        set.put(testData2);
        Assert.equal(set.size(), 2, "expected size of 2");

        //indexOf
        Assert.equal(set.indexOf(testData1), 0, "expected index 0");
        Assert.equal(set.indexOf(testData2), 1, "expected index 1");

        // this is OK because contains() and size()-based iteration should be used instead
        Assert.equal(set.indexOf(notIncluded), 0, "expected index 0");

        //getAt
        Assert.equal(set.getAt(0), testData1, "expected testData1");
        Assert.equal(set.getAt(1), testData2, "expected testData2");

        //contains
        Assert.isTrue(set.contains(testData1), "expected contains testData1");
        Assert.isTrue(set.contains(testData2), "expected contains testData2");
        Assert.isFalse(set.contains(notIncluded), "expected contains testData2");

    }

    function testRemove1Then2() public {
        AddressSet.SetData storage set;

        address testData1 = address(1);
        address testData2 = address(2);
        address notIncluded = address(3);

        set.put(testData1);
        set.put(testData2);

        //remove absent item
        set.remove(notIncluded);
        Assert.equal(set.size(), 2, "expected size of 2");

        //remove first item
        set.remove(testData1);
        Assert.isFalse(set.contains(testData1), "expected not contains testData1");
        Assert.isTrue(set.contains(testData2), "expected contains testData2");
        Assert.equal(set.indexOf(testData2), 0, "expected 2nd item to now have index 0");
        Assert.equal(set.size(), 1, "expected size of 1");

        //remove last item
        set.remove(testData2);
        Assert.isFalse(set.contains(testData2), "expected not contains testData2");
        Assert.equal(set.size(), 0, "expected size of 0");
    }

    function testRemove2Then1() public {
        AddressSet.SetData storage set;

        address testData1 = address(1);
        address testData2 = address(2);
        address notIncluded = address(3);

        set.put(testData1);
        set.put(testData2);

        //remove absent item
        set.remove(notIncluded);
        Assert.equal(set.size(), 2, "expected size of 2");

        //remove 2nd item
        set.remove(testData2);
        Assert.isFalse(set.contains(testData2), "expected not contains testData1");
        Assert.isTrue(set.contains(testData1), "expected contains testData1");
        Assert.equal(set.indexOf(testData1), 0, "expected 1st item to still have index 0");
        Assert.equal(set.size(), 1, "expected size of 1");

        //remove last item
        set.remove(testData1);
        Assert.isFalse(set.contains(testData1), "expected not contains testData1");
        Assert.equal(set.size(), 0, "expected size of 0");
    }
}