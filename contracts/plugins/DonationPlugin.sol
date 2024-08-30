// SPDX-License-Identifier: MIT-Licence
// pragma solidity ^0.8.19;

// import {BasePlugin} from "./BasePlugin.sol";
// import {IPluginExecutor} from "../interfaces/IPluginExecutor.sol";
// import {ManifestFunction, ManifestAssociatedFunctionType, ManifestAssociatedFunction, PluginManifest, PluginMetadata, IPlugin} from "../interfaces/IPlugin.sol";

// /// @title Donation Plugin
// /// @author [Your Name]
// /// @notice This plugin allows users to donate funds to a charity.
// contract DonationPlugin {
//     // metadata used by the pluginMetadata() method down below
//     string public constant NAME = "Donation Plugin";
//     string public constant VERSION = "1.0.0";
//     string public constant AUTHOR = "[Your Name]";

//     // this is a constant used in the manifest, to reference our only dependency: the single owner plugin
//     // since it is the first, and only, plugin the index 0 will reference the single owner plugin
//     // we can use this to tell the modular account that we should use the single owner plugin to validate our user op
//     // in other words, we'll say "make sure the person calling donate is an owner of the account using our single plugin"

//     uint256
//         internal constant _MANIFEST_DEPENDENCY_INDEX_OWNER_USER_OP_VALIDATION =
//         0;

//     mapping(address => mapping(uint256 => DonationData))
//         public donations;

//     struct DonationData {
//         address charityAddress;
//         uint256 amount; // <- native currency
//         bool processed; // true if donation has been processed
//     }

//     // ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
//     // ┃    Execution functions    ┃
//     // ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

//     // this is called through a user operation by the account owner
//     function donate(address charityAddress, uint256 amount) external {
//         require(charityAddress != address(0), "Invalid charity address");
//         require(amount > 0, "Amount must be greater than zero");

//         donations[charityAddress][msg.sender] = DonationData({
//             charityAddress: charityAddress,
//             amount: amount,
//             processed: false
//         });
//     }

//     // this is called directly on the plugin by the collector
//     function processDonation(address donor, address charityAddress, uint256 amount) external {
//         DonationData storage donation = donations[charityAddress][donor];
//         require(donation.amount == amount);
//         require(!donation.processed, "Donation has already been processed");
        
//         // Add logic here to transfer funds to the charity
//         // For example:
//         // (charityAddress).transfer(amount);

//         donation.processed = true;
//         IPluginExecutor(charityAddress).executeFromPluginExternal(
//             msg.sender,
//             amount,
//             ""
//         );
//     }

//     // ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
//     // ┃    Plugin interface functions    ┃
//     // ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

//     /// @inheritdoc BasePlugin
//     function onInstall(bytes calldata) external pure override {}

//     /// @inheritdoc BasePlugin
//     function onUninstall(bytes calldata) external pure override {}

//     /// @inheritdoc BasePlugin
//     function pluginManifest()
//         external
//         pure
//         override
//         returns (PluginManifest memory)
//     {
//         PluginManifest memory manifest;

//         manifest.dependencyInterfaceIds = new bytes4[](1);
//         manifest.dependencyInterfaceIds[0] = type(IPlugin).interfaceId;

//         manifest.executionFunctions = new bytes4[](1);
//         manifest.executionFunctions[0] = this.donate.selector;

//         ManifestFunction
//             memory ownerUserOpValidationFunction = ManifestFunction({
//                 functionType: ManifestAssociatedFunctionType.DEPENDENCY,
//                 functionId: 0, 
//                 dependencyIndex: _MANIFEST_DEPENDENCY_INDEX_OWNER_USER_OP_VALIDATION
//             });

//         manifest.userOpValidationFunctions = new ManifestAssociatedFunction[](
//             1
//         );
//         manifest.userOpValidationFunctions[0] = ManifestAssociatedFunction({
//             executionSelector: this.donate.selector,
//             associatedFunction: ownerUserOpValidationFunction
//         });

//         manifest.preRuntimeValidationHooks = new ManifestAssociatedFunction[](
//             1
//         );
//         manifest.preRuntimeValidationHooks[0] = ManifestAssociatedFunction({
//             executionSelector: this.donate.selector,
//             associatedFunction: ManifestFunction({
//                 functionType: ManifestAssociatedFunctionType.PRE_HOOK_ALWAYS_DENY,
//                 functionId: 0,
//                 dependencyIndex: 0
//             })
//         });

//         manifest.permitAnyExternalAddress = true;
//         manifest.canSpendNativeToken = true;

//         return manifest;
//     }

//     /// @inheritdoc BasePlugin
//     function pluginMetadata()
//         external
//         pure
//         virtual
//         override
//         returns (PluginMetadata memory)
//     {
//         PluginMetadata memory metadata;
//         metadata.name = NAME;
//         metadata.version = VERSION;
//         metadata.author = AUTHOR;
//         return metadata;
//     }
// }