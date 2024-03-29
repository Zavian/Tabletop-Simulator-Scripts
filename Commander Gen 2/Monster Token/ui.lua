--[[StartXML
<Defaults>
    <Image class="state" preserveAspect="true" onclick="manage_state(id)" />
    <Button class="condition" width="150" height="150" iconwidth="85" iconColor="White" onclick="UI_AddCondition(id)" onmouseenter="UI_ShowCondition(id)" onmouseexit="UI_DefaultCondition()" />
</Defaults>
<Panel id="hpPanel" position="0 30 -660" rotation="270 270 90" scale="3 3 3" visibility="Black">
    <ProgressBar id="hpBar" width="175" height="33" color="#000000E0" fillImageColor="#2ECC40" showPercentageText="false" percentage="100" />
    <Text id="hp" width="175" fontSize="34" color="#ffffff" text="" />
    <Text id="oldValue" position="130 0 0" width="60" fontSize="34" minWidth="80" color="#ffffff" text="" fontStyle="Bold" alignment="MiddleLeft" />
    <Text id="ac" position="-130 0 0" width="60" fontSize="34" minWidth="80" color="#ffffff" text="" fontStyle="Bold" />
    <Text id="movement" position="0 40 0" color="#ffffff" fontSize="34" text="Movement" />
    <Button id="tempHP" active="false" position="70 0 0" width="40" height="33" color="#6E74EA" fontSize="20" textColor="white" onclick="UI_ClickTMP" />
</Panel>
<InputField id="calculate" visibility="Black" scale="3 3 3" position="-60 -210 -660" height="60" width="80" fontSize="34" color="#FFFFFF99"></InputField>

<Button id="calculateButton" visibility="Black" scale="3 3 3" position="120 -210 -660" height="60" width="60" fontSize="34" color="#FFFFFF99">C</Button>
<Button id="calculateButtonHalf" visibility="Black" scale="3 3 3" position="120 -80 -660" height="30" width="60" fontSize="20" color="#ac0900aa">½</Button>

<Text id="rolled" visibility="Black" scale="1 1 1" position="60 160 -20" width="100" height="100" fontSize="40" color="#FFFFFF" text="" />
<Button id="hpButton" scale="1 1 1" position="0 30 -660" rotation="270 270 90" height="128" width="128" fontSize="0" color="#FF0000FF" visibility="White|Teal|Brown|Blue|Red|Purple|Orange|Pink|Yellow|Green" />


<Image raycasttarget="false" id="visualizeButton" scale="2.5 2.5 2.5" position="0 30 -980" rotation="270 270 90" height="0" width="0" fontSize="0" color="#FF0000FF" visibility="Black" />
<Image raycasttarget="false" id="visualizeButton2" scale="5 5 5" position="0 0 0" rotation="0 0 0" height="0" width="0" fontSize="0" color="#FF00ffff" visibility="Black" />

<HorizontalLayout scale="3 3 3" width="150" height="40" position="0 0 -950" rotation="270 270 90" id="states" childForceExpandWidth="false" childForceExpandHeight="false">
    <Image class="state" active="false" id="blinded" image="blinded" />
    <Image class="state" active="false" id="charmed" image="charmed" />
    <Image class="state" active="false" id="concentration" image="concentration" />
    <Image class="state" active="false" id="deafened" image="deafened" />
    <Image class="state" active="false" id="frightened" image="frightened" />
    <Image class="state" active="false" id="grappled" image="grappled" />
    <Image class="state" active="false" id="incapacitated" image="incapacitated" />
    <Image class="state" active="false" id="invisible" image="invisible" />
    <Image class="state" active="false" id="on fire" image="on fire" />
    <Image class="state" active="false" id="paralyzed" image="paralyzed" />
    <Image class="state" active="false" id="petrified" image="petrified" />
    <Image class="state" active="false" id="poisoned" image="poisoned" />
    <Image class="state" active="false" id="restrained" image="restrained" />
    <Image class="state" active="false" id="stunned" image="stunned" />
</HorizontalLayout>

<Button id="removeAreaBtn" visibility="Black" textColor="#ffffff" color="#00000099" fontSize="16" width="75" height="75" position="-250 -130 -660" onclick="UI_RemoveArea">Remove Area</Button>

<Button id="conditionMenuToggleBtn" visibility="Black" color="#FFFFFF99" fontSize="32" width="75" height="75" position="-250 -210 -660" onclick="UI_ConditionMenu">+</Button>
<Panel visibility="Black" id="ConditionMenu" active="false" width="550" height="425" position="-600 -250 -660" color="#ffffff99">
    <GridLayout id="condSelector" constraint="FixedColumnCount" constraintCount="5" startCorner="UpperRight" childAlignment="UpperRight" spacing="5" padding="10 10 10 10">
        <Button color="#ffffff" id="btn_blinded" class="condition" icon="blinded"></Button>
        <Button color="#ffffff" id="btn_charmed" class="condition" icon="charmed"></Button>
        <Button color="#ffffff" id="btn_concentration" class="condition" icon="concentration"></Button>
        <Button color="#ffffff" id="btn_deafened" class="condition" icon="deafened"></Button>
        <Button color="#ffffff" id="btn_frightened" class="condition" icon="frightened"></Button>
        <Button color="#ffffff" id="btn_grappled" class="condition" icon="grappled"></Button>
        <Button color="#ffffff" id="btn_incapacitated" class="condition" icon="incapacitated"></Button>
        <Button color="#ffffff" id="btn_invisible" class="condition" icon="invisible"></Button>
        <Button color="#ffffff" id="btn_on_fire" class="condition" icon="on fire"></Button>
        <Button color="#ffffff" id="btn_paralyzed" class="condition" icon="paralyzed"></Button>
        <Button color="#ffffff" id="btn_petrified" class="condition" icon="petrified"></Button>
        <Button color="#ffffff" id="btn_poisoned" class="condition" icon="poisoned"></Button>
        <Button color="#ffffff" id="btn_restrained" class="condition" icon="restrained"></Button>
        <Button color="#ffffff" id="btn_stunned" class="condition" icon="stunned"></Button>
    </GridLayout>
    <Button offsetXY="0 10" rectAlignment="LowerCenter" fontStyle="Bold" fontSize="32" color="#ffffff00" width="530" height="70" id="ConditionType">Condition</Button>
</Panel>

<Text id="BlackName" scale="3 3 3" fontSize="34" visibility="Black" text="Black Name" color="Black" position="0 -150 -200" rotation="270 270 90" fontStyle="Bold" outline="White" outlineSize="1 -1" />
<Text id="BlackRoll" scale="3 3 3" fontSize="34" visibility="Black" text="99" color="Black" position="0 -150 -350" rotation="270 270 90" fontStyle="Bold" outline="White" outlineSize="1 -1" />
StopXML--xml]]