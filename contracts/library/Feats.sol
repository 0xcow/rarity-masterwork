//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "../interfaces/codex/IRarityCodexFeats1.sol";
import "../interfaces/codex/IRarityCodexFeats2.sol";
import "../interfaces/core/IRarityFeats.sol";

library Feats {
  IRarityCodexFeats1 private constant CODEX1 
  = IRarityCodexFeats1(0x88db734E9f64cA71a24d8e75986D964FFf7a1E10);
  IRarityCodexFeats2 private constant CODEX2 
  = IRarityCodexFeats2(0x7A4Ba2B077CD9f4B13D5853411EcAE12FADab89C);
  IRarityFeats private constant FEATS 
  = IRarityFeats(0x4F51ee975c01b0D6B29754657d7b3cC182f20d8a);

  function has_feat(uint summoner, uint feat_id) internal view returns (bool) {
    bool[100] memory feats = FEATS.get_feats(summoner);
    return feats[feat_id - 1];
  }

  function improved_initiative(uint summoner) public view returns (bool) {
    (uint id,,,,,,) = CODEX1.improved_initiative();
    return has_feat(summoner, id);
  }

  function armor_proficiency_light(uint summoner) public view returns (bool) {
    (uint id,,,,,,) = CODEX1.armor_proficiency_light();
    return has_feat(summoner, id);
  }

  function armor_proficiency_medium(uint summoner) public view returns (bool) {
    (uint id,,,,,,) = CODEX1.armor_proficiency_medium();
    return has_feat(summoner, id);
  }

  function armor_proficiency_heavy(uint summoner) public view returns (bool) {
    (uint id,,,,,,) = CODEX1.armor_proficiency_heavy();
    return has_feat(summoner, id);
  }

  function shield_proficiency(uint summoner) public view returns (bool) {
    (uint id,,,,,,) = CODEX1.shield_proficiency();
    return has_feat(summoner, id);
  }

  function tower_shield_proficiency(uint summoner) public view returns (bool) {
    (uint id,,,,,,) = CODEX2.tower_shield_proficiency();
    return has_feat(summoner, id);
  }

  function simple_weapon_proficiency(uint summoner) public view returns (bool) {
    (uint id,,,,,,) = CODEX2.simple_weapon_proficiency();
    return has_feat(summoner, id);
  }

  function martial_weapon_proficiency(uint summoner) public view returns (bool) {
    (uint id,,,,,,) = CODEX2.martial_weapon_proficiency();
    return has_feat(summoner, id);
  }

  function exotic_weapon_proficiency(uint summoner) public view returns (bool) {
    (uint id,,,,,,) = CODEX1.exotic_weapon_proficiency();
    return has_feat(summoner, id);
  }

  function negotiator(uint summoner) public view returns (bool) {
    (uint id,,,,,,) = CODEX2.negotiator();
    return has_feat(summoner, id);
  }

  function investigator(uint summoner) public view returns (bool) {
    (uint id,,,,,,) = CODEX2.investigator();
    return has_feat(summoner, id);
  }

  function diligent(uint summoner) public view returns (bool) {
    (uint id,,,,,,) = CODEX1.diligent();
    return has_feat(summoner, id);
  }
}