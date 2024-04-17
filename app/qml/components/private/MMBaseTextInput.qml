/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// To ignore the warning "The current style does not support customization"
// see from https://stackoverflow.com/questions/76625756/the-current-style-does-not-support-customization-of-this-control
import QtQuick.Controls.Basic

/**
  * MMBaseTextInput serves as a base class for all inputs that can benefit from
  * predefined textfield and/or left/right icons (actions).
  *
  * Private class, do not use standalone in the app.
  */

MMBaseInput {
  id: root

  property alias text: textFieldControl.text
  property alias placeholderText: textFieldControl.placeholderText

  property alias textField: textFieldControl
  property alias textFieldBackground: textFieldBackgroundGroup

  property alias leftContent: leftContentGroup.children
  property alias rightContent: rightContentGroup.children
  property alias leftContentMouseArea: leftContentMouseAreaGroup
  property alias rightContentMouseArea: rightContentMouseAreaGroup

  signal textEdited( string text )
  signal leftContentClicked()
  signal rightContentClicked()

  inputContent: Rectangle {
    id: textFieldBackgroundGroup

    width: parent.width
    height: __style.row50

    color: {
      if ( root.editState !== "enabled" ) return __style.polarColor
      if ( root.validationState === "error" ) return __style.negativeUltraLightColor
      if ( root.validationState === "warning" ) return __style.negativeUltraLightColor

      return __style.polarColor
    }

    border.width: {
      if ( root.validationState === "error" ) return __style.width2
      if ( root.validationState === "warning" ) return __style.width2
      if ( textFieldControl.activeFocus ) return __style.width2
      if ( textFieldControl.hovered ) return __style.width1
      return 0
    }

    border.color: {
      if ( root.editState !== "enabled" ) return __style.polarColor
      if ( root.validationState === "error" ) return __style.negativeColor
      if ( root.validationState === "warning" ) return __style.warningColor
      if ( textFieldControl.activeFocus ) return __style.forestColor
      if ( textFieldControl.hovered ) return __style.forestColor

      return __style.polarColor
    }

    radius: __style.radius12

    RowLayout {
      anchors .fill: parent

      spacing: __style.margin12

      Item {
        id: leftContentGroupContainer

        Layout.preferredHeight: leftContentGroup.height
        Layout.preferredWidth: leftContentGroup.width
        Layout.leftMargin: __style.margin20

        visible: leftContentGroup.children.length > 0 && leftContentGroup.children[0].visible

        Item {
          id: leftContentGroup

          width: childrenRect.width
          height: childrenRect.height

        }

        MouseArea {
          id: leftContentMouseAreaGroup

          anchors {
            fill: parent

            leftMargin: -__style.margin20
            topMargin: -__style.margin16
            rightMargin: -__style.margin12
            bottomMargin: -__style.margin16
          }

          onClicked: function( mouse ) {
            mouse.accepted = true
            root.focus = true
            root.leftContentClicked()
          }
        }
      }

      TextField {
        id: textFieldControl

        Layout.fillWidth: true
        Layout.preferredHeight: parent.height

        readOnly: root.editState === "readOnly" || root.editState === "disabled"

        // Ensure the text is scrolled to the beginning
        Component.onCompleted: ensureVisible( 0 )

        color: {
          if ( root.editState === "readOnly" ) return __style.nightColor
          if ( root.editState === "enabled" ) return __style.nightColor
          if ( root.editState === "disabled" ) return __style.mediumGreyColor
          return __style.nightColor
        }

        topPadding: 0
        bottomPadding: 0
        leftPadding: leftContentGroupContainer.visible ? 0 : __style.margin20
        rightPadding: rightContentGroupContainer.visible ? 0 : __style.margin20

        inputMethodHints: Qt.ImhNoPredictiveText

        placeholderTextColor: __style.darkGreyColor

        font: __style.p5

        background: Rectangle { color: __style.transparentColor }

        onTextEdited: root.textEdited( text )
      }

      Item {
        id: rightContentGroupContainer

        Layout.preferredHeight: rightContentGroup.height
        Layout.preferredWidth: rightContentGroup.width
        Layout.rightMargin: __style.margin20

        visible: rightContentGroup.children.length > 0 && rightContentGroup.children[0].visible

        Item {
          id: rightContentGroup

          width: childrenRect.width
          height: childrenRect.height
        }

        MouseArea {
          id: rightContentMouseAreaGroup

          anchors {
            fill: parent

            leftMargin: -__style.margin12
            topMargin: -__style.margin16
            rightMargin: -__style.margin20
            bottomMargin: -__style.margin16
          }

          onClicked: function( mouse ) {
            mouse.accepted = true
            root.focus = true
            root.rightContentClicked()
          }
        }
      }
    }
  }
}
