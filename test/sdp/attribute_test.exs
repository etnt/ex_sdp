defmodule Membrane.Protocol.SDP.AttributeTest do
  use ExUnit.Case

  alias Membrane.Protocol.SDP.Attribute

  describe "Attribute parser" do
    test "handles framerate" do
      assert {:ok, {:framerate, {30, 1}}} = Attribute.parse("framerate:30/1")
    end

    test "handles directly assignable attributes" do
      assert {:ok, {:cat, "category"}} = Attribute.parse("cat:category")
    end

    test "handles known integer attributes" do
      assert {:ok, {:quality, 7}} = Attribute.parse("quality:7")
    end

    test "returns an error if attribute supposed to be numeric but isn't" do
      assert {:error, :invalid_attribute} = Attribute.parse("ptime:g7")
    end

    test "handles known flags" do
      assert {:ok, :recvonly} = Attribute.parse("recvonly")
    end

    test "handles unknown attribute" do
      assert {:ok, "otherattr"} = Attribute.parse("otherattr")
    end
  end

  describe "Media attribute parser" do
    test "handles rtpmaping" do
      assert {:ok, {:rtpmap, %Attribute.RTPMapping{}}} =
               Attribute.parse_media_attribute({:rtpmap, "98 L16/16000/2"}, :audio)
    end

    test "handles unknown attribute" do
      assert {:ok, {"dunno", "123"}} = Attribute.parse_media_attribute({"dunno", "123"}, :message)
    end
  end

  describe "Attribute serializer" do
    test "serializes framerate attribute" do
      assert Attribute.serialize({:framerate, "value"}) == "a=framerate:value"
    end

    test "serializes flag attributes" do
      assert Attribute.serialize(:sendrecv) == "a=sendrecv"
    end

    test "serializes numeric attributes" do
      assert Attribute.serialize({:maxptime, "100"}) == "a=maxptime:100"
    end

    test "serializes value attributes" do
      assert Attribute.serialize({:type, "some-type"}) == "a=type:some-type"
    end

    test "serializes custom attributes" do
      assert Attribute.serialize({"custom", "attribute"}) == "a=custom:attribute"
    end
  end
end
