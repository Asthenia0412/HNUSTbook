const { expect } = require("chai");

describe("Storage contract", function () {
    let Storage;
    let storage;
    let owner;

    beforeEach(async function () {
        // Get the ContractFactory and Signers here.
        Storage = await ethers.getContractFactory("Storage");
        [owner] = await ethers.getSigners();

        // Deploy a new contract for each test
        storage = await Storage.deploy();
    });

    it("should store and retrieve a value", async function () {
        // Store a value
        await storage.store(42);

        // Retrieve the stored value and check it
        const storedValue = await storage.retrieve();
        expect(storedValue).to.equal(42);
    });

    it("should update stored value", async function () {
        // Store a value
        await storage.store(42);

        // Update the value
        await storage.store(100);

        // Retrieve the updated value
        const updatedValue = await storage.retrieve();
        expect(updatedValue).to.equal(100);
    });
});
